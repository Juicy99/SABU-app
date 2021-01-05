import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'order.dart';

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];
  String newTaskTitle = '';
  String newTaskMessage = '';
  double newTaskPrice = 0;
  int qty = 1;
  File imageFile;
  String name = '';

  void addTask(String newTaskTitle, String newTaskMessage, double newTaskPrice,
      int qty) {
    items.add(
      Order(
          name: newTaskTitle,
          message: newTaskMessage,
          price: newTaskPrice,
          qty: 1),
    );
    notifyListeners();
  }

  clearCart() {
    items.forEach((f) => f.qty = 1);
    items = [];
    notifyListeners();
  }

  removeOrder(o) {
    items.remove(o);
    notifyListeners();
  }

  incrementQty(order) {
    items[items.indexOf(order)].qty += 1;
    notifyListeners();
  }

  decrementQty(order) {
    if (items[items.indexOf(order)].qty == 1) {
      removeOrder(order);
    } else {
      items[items.indexOf(order)].qty -= 1;
      notifyListeners();
    }
  }

  int get itemCount {
    return items.length;
  }

  double get totalPriceAmount {
    var total = 0.0;
    items.forEach((f) {
      total += f.price * f.qty;
    });
    return total;
  }

  String uid;
  List _history;
  List _itemHistory;

  CollectionReference get dataPath =>
      FirebaseFirestore.instance.collection('users/$uid/history');
  CollectionReference get dataPath1 =>
      FirebaseFirestore.instance.collection('users/$uid/itemHistory');
  List get history => _history;
  List get itemHistory => _itemHistory;

  void init(List<DocumentSnapshot> documents) {
    _history = documents.map((doc) => CartHistory.fromMap(doc)).toList();
    _history.sort((a, b) => b.createAt.compareTo(a.createAt));
  }

  void init2(List<DocumentSnapshot> documents) {
    _itemHistory = documents.map((doc) => OrderHistory.fromMap(doc)).toList();
    _itemHistory.sort((a, b) => b.createAt.compareTo(a.createAt));
  }

  void addTitle(double total) {
    dataPath.doc().set({
      'total': total,
      'createAt': DateTime.now(),
    });
  }

  void addItem(
    String name,
    String message,
    double price,
  ) async {
    dataPath1.doc().set({
      'createAt': DateTime.now(),
      'message': message,
      'price': price,
      'name': name,
    });
    notifyListeners();
  }

  Future addBookToFirebase() async {
    final imageURL = await _uploadImageFile();

    dataPath1.add(
      {
        'name': name,
        'imageURL': imageURL,
        'createdAt': Timestamp.now(),
      },
    );
  }

  void deleteDocument2(docId) {
    dataPath1.doc(docId).delete();
  }

  void deleteDocument(docId) {
    dataPath.doc(docId).delete();
  }

  setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<String> _uploadImageFile() async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('itemHistory').child(name);
    final snapshot = await ref.putFile(
      imageFile,
    );
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
