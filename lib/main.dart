import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'order_notify.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => OrderNotify(),
      create: (_) => OrderNotify()..getTodoListRealtime(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
