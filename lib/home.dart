import 'package:flutter/material.dart';

import 'add_task_screen.dart';

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
  ];

  // タブの中身として表示するPageの配列を作成
  List<Widget> _buildTabPages() {
    return [
      AddTaskScreen(),
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
