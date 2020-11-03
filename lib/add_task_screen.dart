import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';
import 'task_screen.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List<String> valueList = [
    'すべて',
    'コンピュータ',
    '家電、AV、カメラ',
    '音楽',
    '本、雑誌',
    '映画、ビデオ',
    'おもちゃ、ゲーム',
    'ホビー、カルチャー',
    'アンティーク、コレクション',
    'スポーツ、レジャー',
    '自動車、オートバイ',
    'ファッション',
    'アクセサリー、時計',
    'ビューティ、ヘルスケア',
    '食品、飲料',
    '住まい、インテリア',
    'ペット、生き物',
    '事務、店舗用品',
    '花、園芸',
    'チケット、金券、宿泊予約',
    'ベビー用品',
    'タレントグッズ',
    'コミック、アニメグッズ',
    '不動産',
    'チャリティー',
    'その他'
  ];
  String _selectedValue;

  List<String> valueList2 = ['新品', '未使用', '動作品', 'ジャンク品'];
  String _selectedValue2;

  final _formKey = GlobalKey<FormState>();

  var _controller = TextEditingController();
  var _controller2 = TextEditingController();
  var _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String newTaskTitle;
    String newTaskMessage;
    String newTaskPrice;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButton(
                  value: _selectedValue ?? valueList[0],
                  items: valueList.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: '商品名を記入'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    newTaskTitle = value;
                  },
                  validator: (value) {
                    // 入力内容が空でないかチェック
                    if (value.isEmpty) {
                      return '商品名を入力してください。';
                    }
                    return null;
                  },
                ),
                DropdownButton(
                  value: _selectedValue2 ?? valueList2[0],
                  items: valueList2.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue2 = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _controller2,
                  decoration: InputDecoration(labelText: '査定金額を記入してください'),
                  obscureText: false,
                  maxLines: 1,
                  maxLength: 10,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newTaskPrice = value;
                  },
                  validator: (value) {
                    if (value.length == 0 || int.parse(value) <= 0) {
                      return ('金額を記入してください');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controller3,
                  decoration: InputDecoration(
                      hintText: '例（限定品）', labelText: '何かメモがあれば記入してください'),
                  onChanged: (value) {
                    newTaskMessage = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('カートを確認'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TasksScreen()),
                          );
                        }),
                    RaisedButton(
                      child: Text('カートにこの商品を入れる'),
                      onPressed: () {
                        if (_formKey.currentState.validate())
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("確認"),
                                    content: Text("この商品をカートに追加しますか？"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'キャンセル',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          _controller.clear();
                                          _controller2.clear();
                                          _controller3.clear();
                                          Provider.of<TaskData>(context)
                                              .addTask(
                                                  newTaskTitle ?? '',
                                                  newTaskMessage ?? '',
                                                  newTaskPrice ?? '');
                                          Navigator.pop(context);
                                          return Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TasksScreen()),
                                          );
                                        },
                                        child: Text('追加'),
                                      ),
                                    ],
                                  ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
