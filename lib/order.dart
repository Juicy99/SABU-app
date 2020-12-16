import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;

  Order.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    message = data['message'];
    price = data['price'];
    qty = data['qty'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'price': price,
      'qty': qty,
    };
  }

  Order({this.qty, this.product, this.price, this.message, this.name});
}

class OrderHistory {
  OrderHistory(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    this.name = doc.data()['name'];
    this.price = doc.data()['price'];
    this.message = doc.data()['message'];
    final totalPriceAmount = doc.data()['total'];
    this.total = totalPriceAmount;
    this.qty = doc.data()['qty'];
    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
    documentId = doc.id;
  }

  String documentId;
  String name;
  String message;
  int qty = 1;
  double price;
  double total;
  DateTime createdAt;
  DocumentReference documentReference;
}

class CartHistory {
  CartHistory(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    final totalPriceAmount = doc.data()['total'];
    this.total = totalPriceAmount;

    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
    documentId = doc.id;
  }

  String documentId;
  double total;
  DateTime createdAt;
  bool isDone = false;
  DocumentReference documentReference;
}
