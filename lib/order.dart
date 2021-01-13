import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  DocumentReference reference;
  String imageURL;

  Order.fromMap(Map<String, dynamic> map()) {
    name = map()['name'];
    message = map()['message'];
    price = map()['price'];
    qty = map()['qty'];
    imageURL = map()['imageURL'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'price': price,
      'qty': qty,
      'imageURL': imageURL,
    };
  }

  Order({this.qty, this.price, this.message, this.name, this.imageURL});
}

class CartHistory {
  String _docId;
  double total;
  Timestamp _createAt;

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

class CartHistory2 {
  double total;
  Timestamp createAt;
  CartHistory2(
    this.total,
    this.createAt,
  );

  CartHistory2.fromMap(Map<String, dynamic> map())
      : assert(map()['total'] != null),
        assert(map()['createAt'] != null),
        total = map()['total'],
        createAt = map()['createAt'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['total'] = total;
    map['createAt'] = createAt;
    return map;
  }

  @override
  String toString() => "Record<$total:$createAt>";
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

class OrderList {
  String name;
  String message;
  int qty;
  double price;
  String imageURL;

  OrderList({this.name, this.message, this.price, this.qty, this.imageURL});

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
