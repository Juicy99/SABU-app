import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order.dart';

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];
  String newTaskTitle = '';
  String newTaskMessage = '';
  double newTaskPrice = 0;
  int qty = 1;

  List<CartHistory> cartHistory = [];
  List<OrderHistory> orderHistory = [];

  Future fireAdd() async {
    final docRef =
        await FirebaseFirestore.instance.collection('cartHistory').add({
      'createdAt': Timestamp.now(),
      'total': totalPriceAmount,
    });
    docRef.collection('orderHistory').add({
      'itemHistory': items.map((i) => i.toMap()).toList(),
    });
  }

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

  OrderNotify();

  CollectionReference get dataPath =>
      FirebaseFirestore.instance.collection('users/$uid/history');
  List get history => _history;

  void init(List<DocumentSnapshot> documents) {
    _history = documents.map((doc) => CartHistory.fromMap(doc)).toList();
  }

  void init2(List<DocumentSnapshot> documents) {
    _history = documents.map((doc) => OrderHistory.fromMap(doc)).toList();
  }

  void addTitle(double total) {
    dataPath.doc().set({
      'total': total,
      'createAt': DateTime.now(),
    });
  }

  void addItem(
    name,
  ) {
    dataPath.doc().set({
      'name': name,
    });
    notifyListeners();
  }

  void deleteDocument(docId) {
    dataPath.doc(docId).delete();
  }
}
