import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;

  Order({this.qty, this.product, this.price, this.message, this.name});
}

class Order2 {
  Order2(DocumentSnapshot doc) {
    this.name = doc.data()['name'];
    this.message = doc.data()['message'];
    this.price = doc.data()['price'];
    this.qty = doc.data()['qty'];
    this.product = doc.data()['product'];
  }

  String name;
  String message;
  int qty = 1;
  double price;
  Product product;
}

class History {
  History(DocumentSnapshot doc) {
    this.title = doc.data()['title'];

    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String title;
  DateTime createdAt;
}
