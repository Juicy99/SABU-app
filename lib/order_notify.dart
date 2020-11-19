import 'package:flutter/material.dart';

import 'order.dart';

List<Order> items = [
  Order(name: 'Buy milk', message: 'Buy milk', price: 10),
  Order(name: 'Buy eggs', message: 'Buy eggs', price: 100),
  Order(name: 'Buy bread', message: 'Buy bread', price: 1000),
];

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];

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
