import 'package:flutter/material.dart';

import 'add_task_screen.dart';
import 'cart_page.dart';
import 'schedule_page.dart';
import 'zaiko_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// "with SingleTickerProviderStateMixin"を追記
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Tabの配列を作成
  List<Widget> _tab = [
    Tab(text: '査定', icon: Icon(Icons.shopping_basket)),
    Tab(text: '在庫', icon: Icon(Icons.widgets)),
    Tab(text: '買取履歴', icon: Icon(Icons.shopping_cart)),
    Tab(text: 'カレンダー', icon: Icon(Icons.perm_contact_calendar)),
  ];

  // タブの中身として表示するPageの配列を作成
  List<Widget> _buildTabPages() {
    return [
      AddTaskScreen(),
      ZaikoPage(),
      CartPage(),
      SchedulePage(),
    ];
  }

  // コントローラーの作成
  TabController _controller;

  @override

  // コントローラーの設定
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
            controller: _controller, // コントローラーをセット
            tabs: _tab, // タブ部分の中身
            labelColor: Colors.black, // 選択されているタブの文字色
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.white, // 選択されていないタブの文字色
          ),
        ),
        body: TabBarView(
          controller: _controller, // コントローラーをセット
          children: _buildTabPages(), // タブの中身として表示するPageの配列をセット
        ),
      ),
    );
  }
}
