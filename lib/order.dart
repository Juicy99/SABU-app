import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'product.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;

  Order({this.qty, this.product, this.price, this.message, this.name});
}

class History {
  History(DocumentSnapshot doc) {
    this.title = doc.data()['title'];
    this.total = doc.data()['amount'];
    this.products = doc.data()['products'];

    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  double total;
  List<Order> products;
  String title;
  DateTime createdAt;
}

class OrderItem {
  final String id;
  final double amount;
  final List<Order> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
