import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  User _user;
  Status _status = Status.uninitialized;

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_authStateChanges);
  }

  User get user => _user;
  FirebaseAuth get auth => _auth;
  Status get status => _status;

  // firebase auth側の匿名認証を有効にするのを忘れずに
  Future<void> signInAnonymously() async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInAnonymously();
      _status = Status.authenticated;
      notifyListeners();
    } catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _authStateChanges(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.authenticated;
    }
    notifyListeners();
  }
}

class CartService extends ChangeNotifier {
  String uid;
  List _cart;

  CartService();

  CollectionReference get dataPath =>
      FirebaseFirestore.instance.collection('users/$uid/cart');
  List get cart => _cart;

  void init(List<DocumentSnapshot> documents) {
    _cart = documents.map((doc) => CartModel.fromMap(doc)).toList();
  }

  void addTitle(double name) {
    dataPath.doc().set({'name': name, 'createAt': DateTime.now()});
  }

  void deleteDocument(docId) {
    dataPath.doc(docId).delete();
  }
}
