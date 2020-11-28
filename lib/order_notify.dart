import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order.dart';

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];
  String newTaskTitle = '';
  String newTaskMessage = '';
  double newTaskPrice = 0;
  int qty = 1;

  List<History> cartHistory = [];

  Future getHistory() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('cartHistory').get();
    final docs = snapshot.docs;
    final cartHistory = docs.map((doc) => History(doc)).toList();
    this.cartHistory = cartHistory;
    notifyListeners();
  }

  void getHistoryRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('cartHistory').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final cartHistory = docs.map((doc) => History(doc)).toList();
      cartHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.cartHistory = cartHistory;
      notifyListeners();
    });
  }

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('cartHistory');
    await collection.add({
      'createdAt': Timestamp.now(),
    });
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
    calculateTotal();
    notifyListeners();
  }

  removeOrder(o) {
    items.remove(o);
    calculateTotal();
    notifyListeners();
  }

  incrementQty(order) {
    items[items.indexOf(order)].qty += 1;
    calculateTotal();
    notifyListeners();
  }

  decrementQty(order) {
    if (items[items.indexOf(order)].qty == 1) {
      removeOrder(order);
    } else {
      items[items.indexOf(order)].qty -= 1;
      calculateTotal();
      notifyListeners();
    }
  }

  int get itemCount {
    return items.length;
  }

  double totalCartValue = 0;

  void calculateTotal() {
    totalCartValue = 0;
    items.forEach((f) {
      totalCartValue += f.price * f.qty;
    });
  }
}
