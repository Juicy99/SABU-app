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
  String _name;

  OrderHistory(
    this._name,
  );

  String get name => _name;

  OrderHistory.fromMap(map) {
    _name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
