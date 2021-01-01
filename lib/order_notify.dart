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
  List _itemHistory;

  OrderNotify();

  CollectionReference get dataPath =>
      FirebaseFirestore.instance.collection('users/$uid/history');
  CollectionReference get dataPath1 =>
      FirebaseFirestore.instance.collection('users/$uid/itemHistory');
  List get history => _history;

  void init(List<DocumentSnapshot> documents) {
    _history = documents.map((doc) => CartHistory.fromMap(doc)).toList();
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
    FirebaseFirestore.instance.collection('users/$uid/itemHistory').doc().set({
      'name': name,
    });
    notifyListeners();
  }

  void deleteDocument(docId) {
    dataPath.doc(docId).delete();
  }

  List<Todo> itemHistory = [];

  Future getTodoList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users/$uid/itemHistory')
        .get();
    final docs = snapshot.docs;
    final itemHistory = docs.map((doc) => Todo(doc)).toList();
    this.itemHistory = itemHistory;
    notifyListeners();
  }

  void getTodoListRealtime() {
    final snapshots = FirebaseFirestore.instance
        .collection('users/$uid/itemHistory')
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itemHistory = docs.map((doc) => Todo(doc)).toList();
      this.itemHistory = itemHistory;
      notifyListeners();
    });
  }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = itemHistory.where((todo) => todo.isDone).toList();
    final references =
        checkedItems.map((todo) => todo.documentReference).toList();

    final batch = FirebaseFirestore.instance.batch();

    references.forEach((reference) {
      batch.delete(reference);
    });
    return batch.commit();
  }

  bool checkShouldActiveCompleteButton() {
    final checkedItems = itemHistory.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
