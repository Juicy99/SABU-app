import 'package:flutter/material.dart';

import 'order.dart';
import 'product.dart';

List<Product> items = [
  Product(
      image:
          'https://upl.stack.com/wp-content/uploads/2015/01/How-to-Build-Your-Meal-Plan-According-to-Body-Type_STACK.jpg',
      name: 'Food & xxx',
      message: 'Food & xx....',
      price: 100),
  Product(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ02o6hJho_3k3Rhbow9IL6pToV1JVqi2OHXFprdFV2GoHJQWEy&usqp=CAU',
      name: 'Food & Wine Magazine',
      message: 'Food & Wine Magazine....',
      price: 1000)
];

class OrderNotify extends ChangeNotifier {
  List<Order> items = [];

  void addOrder(Order order) {
    // check list product in item
    final i = items.indexWhere((e) => e.product == order.product);
    if (i > -1) {
      items[i].qty += order.qty;
    } else {
      this.items.add(order);
    }
    notifyListeners();
  }

  void addTask(
      String newTaskTitle, String newTaskMessage, double newTaskPrice) {
    items.add(
      Order(name: newTaskTitle, message: newTaskMessage, price: newTaskPrice),
    );
    notifyListeners();
  }

  removeOrder(o) {
    items.remove(o);
    notifyListeners();
  }

  decrementQty(order) {
    final i = items.indexWhere((e) => e.product == order.product);
    if (items[i].qty == 1) {
      removeOrder(order);
    } else {
      items[i].qty -= 1;
      notifyListeners();
    }
  }

  incrementQty(order) {
    items[items.indexOf(order)].qty += 1;
    notifyListeners();
  }

  int get itemCount {
    return items.length;
  }
}
