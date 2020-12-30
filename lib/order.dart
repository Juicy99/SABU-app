import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class CartModel {
  String _docId;
  String name;
  String message;
  Timestamp _createAt;

  CartModel(
    this._docId,
    this.name,
    this._createAt,
  );

  String get docId => _docId;
  String get name1 => name;
  Timestamp get createAt => _createAt;

  CartModel.fromMap(map) {
    _docId = map.documentID;
    name = map['name'];
    _createAt = map['createAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['createAt'] = _createAt;
    return map;
  }
}

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;
  DocumentReference reference;

  Order.fromMap(Map<String, dynamic> map(), {this.reference}) {
    name = map()['name'];
    message = map()['message'];
    price = map()['price'];
    qty = map()['qty'];
  }
  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

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
  String _docId;
  double total;
  Timestamp _createAt;
  bool isDone = false;
  DocumentReference documentReference;

  CartHistory(
    this._docId,
    this.total,
    this._createAt,
  );

  String get docId => _docId;
  double get totalPriceAmount => total;
  Timestamp get createAt => _createAt;

  CartHistory.fromMap(map) {
    _docId = map.documentID;
    total = map['total'];
    _createAt = map['createAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['total'] = total;
    map['createAt'] = _createAt;
    return map;
  }
}
