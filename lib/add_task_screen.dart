import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'order_notify.dart';
import 'screen_order.dart';

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

  var _nameController = TextEditingController();
  var _priceController2 = TextEditingController();
  var _messageController3 = TextEditingController();

  double newTaskPrice = 0;

  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    String newTaskTitle;
    String newTaskMessage;
    double newTaskPrice;
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
                  controller: _nameController,
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
                  controller: _priceController2,
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
                    newTaskPrice.toString();
                  },
                  validator: (value) {
                    if (value.length == 0 || double.parse(value) <= 0) {
                      return ('金額を記入してください');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _messageController3,
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
                                builder: (context) => ScreenOrder()),
                          );
                          newTaskPrice = double.parse(_priceController2.text);
                          order.addItem(
                            _nameController.text,
                            _messageController3.text,
                            double.parse(_priceController2.text),
                          );
                          Provider.of<OrderNotify>(context, listen: false)
                              .addTask(newTaskTitle ?? '', newTaskMessage ?? '',
                                  newTaskPrice ?? '', qty = 1);
                          _nameController.clear();
                          _priceController2.clear();
                          _messageController3.clear();
                          Navigator.pop(context);
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenOrder()),
                          );
                        }),
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
