import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/auth_service.dart';
import 'package:sateiv2_app/provider/order_notify.dart';

class CartHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    historyService.uid = authService.user.uid;
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
              body: Center(
                child: ListView.builder(
                  itemCount: historyService.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _date =
                        historyService.history[index].createAt.toDate();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black38),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_basket,
                            color: Colors.teal, size: 40.0),
                        title: Text(
                            '${historyService.history[index].total.toStringAsFixed(0)}円'),
                        subtitle: Text(
                          DateFormat("yyyy年MM月dd日hh時mm分　　　　　　　　　　　　　　　")
                                  .format(_date) +
                              ("クーリングオフ終了まで${_date.add(Duration(days: 8)).difference(DateTime.now()).inDays.toString()}日"),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog<int>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("本当に削除しますか？"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'キャンセル',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        historyService.deleteDocument(
                                            historyService
                                                .history[index].docId);
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
                      ),
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

class CartHistoryPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    historyService.uid = authService.user.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: historyService.dataPath.orderBy("createAt").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            historyService.init(snapshot.data.docs);
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.teal,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                  ),
                  title: Text('買取履歴')),
              body: Center(
                child: ListView.builder(
                  itemCount: historyService.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _date =
                        historyService.history[index].createAt.toDate();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black38),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_basket,
                            color: Colors.teal, size: 40.0),
                        title: Text(
                            '${historyService.history[index].total.toStringAsFixed(0)}円'),
                        subtitle: Text(
                          DateFormat("yyyy年MM月dd日hh時mm分　　　　　　　　　　　　　　　")
                                  .format(_date) +
                              ("クーリングオフ終了まで${_date.add(Duration(days: 8)).difference(DateTime.now()).inDays.toString()}日"),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog<int>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("本当に削除しますか？"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'キャンセル',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        historyService.deleteDocument(
                                            historyService
                                                .history[index].docId);
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
                      ),
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
