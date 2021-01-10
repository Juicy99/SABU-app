import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  String imageURL;

  Order({this.name, this.message, this.price, this.qty, this.imageURL});

  dynamic toJson() => {
        'name': name,
        'message': message,
        'price': price,
        'qty': qty,
        'imageURL': imageURL,
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      message: json['message'],
      price: json['price'],
      qty: json['qty'],
      imageURL: json['imageURL'],
    );
  }
}

class CartItem {
  String docId;
  double total;
  Timestamp createAt;

  CartItem({
    this.docId,
    this.total,
    this.createAt,
  });

  dynamic toJson() => {
        'docId': docId,
        'total': total,
        'createAt': createAt,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      docId: json['docId'],
      total: json['total'],
      createAt: json['createAt'],
    );
  }
}

class Main {
  final String docId;
  final double total;
  final Timestamp createAt;

  Main({
    this.docId,
    this.total,
    this.createAt,
  });

  dynamic toJson() => {
        'docId': docId,
        'total': total,
        'createAt': createAt,
      };

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      docId: json['docId'],
      total: json['total'],
      createAt: json['createAt'],
    );
  }
}

class OrderList {
  String name;
  String message;
  int qty;
  double price;
  String imageURL;

  OrderList({
    this.name,
    this.message,
    this.price,
    this.qty,
    this.imageURL,
  });

  dynamic toJson() => {
        'name': name,
        'message': message,
        'price': price,
        'qty': qty,
        'imageURL': imageURL,
      };

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      name: json['name'],
      message: json['message'],
      price: json['price'],
      qty: json['qty'],
      imageURL: json['imageURL'],
    );
  }
}

class CartHistory {
  String _docId;
  double total;
  Timestamp _createAt;
  DocumentReference documentReference;
  List<dynamic> _historyHistory;

  CartHistory(
    this._docId,
    this.total,
    this._createAt,
    this._historyHistory,
  );

  String get docId => _docId;
  double get totalPriceAmount => total;
  Timestamp get createAt => _createAt;
  List<dynamic> get historyHistory => _historyHistory;

  CartHistory.fromMap(map) {
    _docId = map.documentID;
    _createAt = map['createAt'];
    total = map['total'];
    _historyHistory = map['historyHistory'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['total'] = total;
    map['createAt'] = _createAt;
    map['historyHistory'] = _historyHistory;
    return map;
  }
}

class OrderHistory {
  String _docId;
  String _name;
  String _message;
  double _price;
  Timestamp _createAt;
  String _imageURL;

  OrderHistory(
    this._docId,
    this._name,
    this._createAt,
    this._price,
    this._message,
    this._imageURL,
  );

  String get docId => _docId;
  String get name => _name;
  String get message => _message;
  double get price => _price;
  Timestamp get createAt => _createAt;
  String get imageURL => _imageURL;

  OrderHistory.fromMap(map) {
    _docId = map.documentID;
    _name = map['name'];
    _message = map['message'];
    _price = map['price'];
    _createAt = map['createAt'];
    _imageURL = map['imageURL'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = _name;
    map['message'] = _message;
    map['price'] = _price;
    map['createAt'] = _createAt;
    map['imageURL'] = _imageURL;
    return map;
  }
}
