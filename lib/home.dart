import 'package:flutter/material.dart';

import 'Item_page.dart';
import 'add_task_screen.dart';
import 'cart_page.dart';
import 'chart_page.dart';
import 'screen_order.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> _tab = [
    Tab(text: '査定', icon: Icon(Icons.shopping_basket)),
    Tab(text: '記録', icon: Icon(Icons.widgets)),
    Tab(text: 'カート', icon: Icon(Icons.shopping_cart)),
    Tab(text: '履歴', icon: Icon(Icons.history)),
    Tab(text: '比較', icon: Icon(Icons.insert_chart)),
  ];

  List<Widget> _buildTabPages() {
    return [
      AddTaskScreen(),
      ItemPage(),
      ScreenOrder(),
      CartPage2(),
      ChartPage(),
    ];
  }

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tab.length, vsync: this);
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("出張買取管理アプリ"),
          backgroundColor: Colors.teal,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            ),
          ],
          bottom: TabBar(
            controller: _controller,
            tabs: _tab,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: _buildTabPages(),
        ),
      ),
    );
  }
}
