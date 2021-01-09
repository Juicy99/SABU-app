import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'auth_service.dart';
import 'main.dart';
import 'order_history_list.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath.orderBy("createAt").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init(snapshot.data.docs);
            return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                  ),
                  title: Center(
                      child:
                          Text('買取履歴\n(${isRelease() ? 'リリース' : 'デバック'}モード)'))),
              body: Center(
                child: ListView.builder(
                  itemCount: historyService.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _date =
                        historyService.history[index].createAt.toDate();
                    return ListTile(
                      title: Text(
                          '${historyService.history[index].total.toStringAsFixed(0)}円'),
                      subtitle: Text(
                        DateFormat("yyyy年MM月dd日hh時mm分").format(_date),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog<int>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("本当に削除しますか？"),
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'キャンセル',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      historyService.deleteDocument(
                                          historyService.history[index].docId);
                                      Navigator.pop(context);
                                    },
                                    child: Text('削除'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("タイトル"),
                              content: Text(
                                  'クーリングオフ期間の終了まであと${_date.add(Duration(days: 14)).difference(_date).inDays.toString()}日'),
                              actions: <Widget>[
                                // ボタン領域
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}

class CartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath.orderBy("createAt").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init(snapshot.data.docs);
            return Scaffold(
              appBar: AppBar(
                  title: Center(
                      child:
                          Text('買取履歴\n(${isRelease() ? 'リリース' : 'デバック'}モード)'))),
              body: Center(
                child: ListView.builder(
                  itemCount: historyService.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _date =
                        historyService.history[index].createAt.toDate();
                    return ListTile(
                      title: Text(
                          '${historyService.history[index].total.toStringAsFixed(0)}円'),
                      subtitle: Text(
                        DateFormat("yyyy年MM月dd日hh時mm分").format(_date),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog<int>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("本当に削除しますか？"),
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'キャンセル',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      historyService.deleteDocument(
                                          historyService.history[index].docId);
                                      Navigator.pop(context);
                                    },
                                    child: Text('削除'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        historyService.getOrderList();
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenOrder1()),
                        );
                      },
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
