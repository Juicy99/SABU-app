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

class OrderHistory {
  OrderHistory(DocumentSnapshot doc) {
    this.name = doc.data()['name'];
    this.message = doc.data()['message'];
    this.price = doc.data()['price'];
    this.qty = doc.data()['qty'];
    this.documentReference = doc.reference;

    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
    id = doc.id;
  }

  String name;
  String message;
  int qty = 1;
  double price;
  String id;
  DateTime createdAt;
  DocumentReference documentReference;
}

class History {
  History(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    final totalPriceAmount = doc.data()['total'];
    this.total = totalPriceAmount;
    this.products = doc.data()['products'];

    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
    id = doc.id;
  }

  String id;
  double total;
  List<Order> products;
  DateTime createdAt;
  bool isDone = false;
  DocumentReference documentReference;
}
