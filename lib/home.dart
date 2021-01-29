import 'package:flutter/material.dart';

import 'Item_page.dart';
import 'add_task_screen.dart';
import 'cart_page.dart';
import 'chart_page.dart';
import 'my_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> _tab = [
    Tab(text: '査定', icon: Icon(Icons.search)),
    Tab(text: '商品', icon: Icon(Icons.note)),
    Tab(text: '履歴', icon: Icon(Icons.history)),
    Tab(text: 'グラフ', icon: Icon(Icons.insert_chart)),
    Tab(text: '設定', icon: Icon(Icons.settings)),
  ];

  List<Widget> _buildTabPages() {
    return [
      AddTaskScreen(),
      ItemPage(),
      CartPage2(),
      ChartPage(),
      MyPage(),
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: Colors.teal,
            bottom: TabBar(
              controller: _controller,
              tabs: _tab,
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              unselectedLabelColor: Colors.white,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
            ),
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
