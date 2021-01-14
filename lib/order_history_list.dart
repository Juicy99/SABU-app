import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'order_notify.dart';

class ScreenOrder1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<OrderNotify>(context, listen: false);
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
            List<DocumentSnapshot> steps = snapshot.data.docs;
            return ListView.builder(
              itemCount: steps.length,
              itemBuilder: (BuildContext context, int index) {
                List steps =
                    List.castFrom(snapshot.data.docs[index]["orderHistory"]);
                return Container(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  height: 200,
                  child: Card(
                    color: Colors.white70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width) / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.network('${steps[index]['imageURL']}'),
                            ],
                          ),
                        ),
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 100) / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 1.0),
                                    width: 150,
                                    child: Text(
                                      '${steps[index]['name']}円',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
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
                                                      color: Colors.redAccent),
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: () {},
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        "${steps[index]['message']}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {},
                                          ),
                                          Text(
                                            "${steps[index]['qty']}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon:
                                                Icon(Icons.add_circle_outline),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        "${steps[index]['price']}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
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
            );
        }
      },
    );
  }
}
