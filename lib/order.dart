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
