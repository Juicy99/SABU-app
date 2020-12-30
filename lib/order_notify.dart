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

  Future getOrderHistory() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orderHistory').get();
    final docs = snapshot.docs;
    final orderHistory = docs.map((doc) => OrderHistory(doc)).toList();
    this.orderHistory = orderHistory;
    notifyListeners();
  }

  void getOrderHistoryRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('orderHistory').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final orderHistory = docs.map((doc) => OrderHistory(doc)).toList();
      orderHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.orderHistory = orderHistory;
      notifyListeners();
    });
  }

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

  bool checkShouldActiveCompleteButton() {
    final checkedItems = cartHistory.where((cart) => cart.isDone).toList();
    return checkedItems.length > 0;
  }

  void reload() {
    notifyListeners();
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

  void addTitle(double total) {
    dataPath.doc().set({
      'total': total,
      'createAt': DateTime.now(),
      'itemHistory': items.map((i) => i.toMap()).toList(),
    });
  }

  void deleteDocument(docId) {
    dataPath.doc(docId).delete();
  }
}
