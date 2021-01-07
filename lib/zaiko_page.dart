import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';
import 'package:sateiv2_app/screen_order.dart';

import 'auth_service.dart';
import 'main.dart';
import 'order_notify.dart';

// ignore: must_be_immutable
class ItemPage extends StatelessWidget {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath1.orderBy("createAt").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init2(snapshot.data.docs);
            return Scaffold(
              appBar: AppBar(
                  title: Center(
                      child: Text(
                          '在庫ページ\n(${isRelease() ? 'リリース' : 'デバック'}モード)'))),
              body: Center(
                child: ListView.builder(
                  itemCount: historyService.itemHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _date =
                        historyService.itemHistory[index].createAt.toDate();
                    return Container(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                      height: 200,
                      child: Card(
                        color: Colors.white70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: (MediaQuery.of(context).size.width) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.network(historyService
                                      .itemHistory[index].imageURL),
                                ],
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width - 100) /
                                  1.5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        width: 150,
                                        child: Image.network(historyService
                                            .itemHistory[index].name),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 26,
                                        ),
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
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      historyService
                                                          .deleteDocument2(
                                                              historyService
                                                                  .itemHistory[
                                                                      index]
                                                                  .docId);
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
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            historyService
                                                .itemHistory[index].message,
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("yyyy年MM月dd日hh時mm分")
                                              .format(_date),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            historyService
                                                    .itemHistory[index].price
                                                    .toStringAsFixed(0) +
                                                '\円 ',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        RaisedButton(
                                            child: Text('カートに追加'),
                                            onPressed: () {
                                              Provider.of<OrderNotify>(context,
                                                      listen: false)
                                                  .addTask(
                                                      historyService
                                                          .itemHistory[index]
                                                          .name,
                                                      historyService
                                                          .itemHistory[index]
                                                          .message,
                                                      historyService
                                                          .itemHistory[index]
                                                          .price,
                                                      qty = 1,
                                                      historyService
                                                          .itemHistory[index]
                                                          .imageURL);
                                              return Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ScreenOrder()),
                                              );
                                            }),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
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
