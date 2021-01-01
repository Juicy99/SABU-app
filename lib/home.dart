import 'package:flutter/material.dart';

import 'add_task_screen.dart';
import 'cart_page.dart';
import 'schedule_page.dart';
import 'zaiko_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> _tab = [
    Tab(text: '査定', icon: Icon(Icons.shopping_basket)),
    Tab(text: '在庫', icon: Icon(Icons.widgets)),
    Tab(text: '買取履歴', icon: Icon(Icons.shopping_cart)),
    Tab(text: 'カレンダー', icon: Icon(Icons.perm_contact_calendar)),
  ];

  List<Widget> _buildTabPages() {
    return [
      AddTaskScreen(),
      ItemPage(),
      CartPage(),
      SchedulePage(),
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
              child: Icon(Icons.settings),
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
