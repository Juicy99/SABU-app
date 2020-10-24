import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(ZaikoPage());
}

class ZaikoPage extends StatefulWidget {
  @override
  _ZaikoPageState createState() => _ZaikoPageState();
}

Timer timer;
var value = 0;

class _ZaikoPageState extends State<ZaikoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          ],
          title: Text(
            '在庫',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Container(),
      ),
    ); // MaterialApp
  }
}
