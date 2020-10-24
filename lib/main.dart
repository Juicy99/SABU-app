import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'task_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => TaskData(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
