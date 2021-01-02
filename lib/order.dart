import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;
  DocumentReference reference;

  Order.fromMap(Map<String, dynamic> map()) {
    name = map()['name'];
    message = map()['message'];
    price = map()['price'];
    qty = map()['qty'];
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
    _createAt = map['createAt'];
    total = map['total'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['total'] = total;
    map['createAt'] = _createAt;
    return map;
  }
}

class OrderHistory {
  String _docId;
  String _name;
  Timestamp _createAt;

  OrderHistory(
    this._docId,
    this._name,
    this._createAt,
  );

  String get docId => _docId;
  String get name => _name;
  Timestamp get createAt => _createAt;

  OrderHistory.fromMap(map) {
    _docId = map.documentID;
    _name = map['name'];
    _createAt = map['createAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['createAt'] = _createAt;
    return map;
  }
}
