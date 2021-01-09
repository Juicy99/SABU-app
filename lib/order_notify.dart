import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'order.dart';

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];
  List<OrderList> orderList = [];
  String newTaskTitle = '';
  String newTaskMessage = '';
  double newTaskPrice = 0;
  int qty = 1;
  File imageFile;

  void addTask(
    String newTaskTitle,
    String newTaskMessage,
    double newTaskPrice,
    int qty,
    String imageURL,
  ) {
    items.add(
      Order(
          name: newTaskTitle,
          message: newTaskMessage,
          price: newTaskPrice,
          qty: 1,
          imageURL: imageURL),
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
  String docId;

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

  void addItem(
    String name,
    String message,
    double price,
  ) async {
    final imageURL = await _uploadImageFile();
    dataPath1.doc().set({
      'createAt': DateTime.now(),
      'message': message,
      'price': price,
      'name': newTaskTitle,
      'imageURL': imageURL,
    });
    notifyListeners();
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
    final ref = storage.ref().child('itemHistory').child(newTaskTitle);
    await FlutterNativeImage.compressImage(imageFile.path, quality: 70);
    final snapshot = await ref.putFile(
      imageFile,
    );
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<List<OrderList>> getOrderList() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users/$uid/history').get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    final orderList =
        docs.map((doc) => OrderList.fromJson(doc.data())).toList();
    return orderList;
  }

  void addTitle(double total) {
    dataPath.doc().set({
      'total': total,
      'createAt': DateTime.now(),
      'orderHistory': items.map((i) => i.toJson()).toList(),
    });
  }

  void onPressed(docId) {
    FirebaseFirestore.instance
        .collection('users/$uid/history')
        .doc(docId)
        .get()
        .then((value) {
      print(value.data());
    });
  }
}
