import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/auth_service.dart';
import 'package:sateiv2_app/provider/order_notify.dart';
import 'package:sateiv2_app/screens/cart_page.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String name = "";
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    historyService.uid = authService.user.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: '査定結果を検索'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? historyService.dataPath1
                .orderBy("createAt")
                .where("name", isEqualTo: name)
                .snapshots()
            : historyService.dataPath1.orderBy("createAt").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              historyService.init2(snapshot.data.docs);
              return Scaffold(
                body: Center(
                  child: ListView.builder(
                    itemCount: historyService.itemHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _date =
                          historyService.itemHistory[index].createAt.toDate();
                      return Container(
                        padding:
                            EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                        height: 200,
                        child: Card(
                          color: Colors.teal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width) / 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      historyService
                                          .itemHistory[index].imageURL,
                                      errorBuilder: (BuildContext context,
                                          Object error, StackTrace stackTrace) {
                                        return Text(
                                          'NO IMAGE'.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
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
                                          child: Text(
                                            historyService
                                                .itemHistory[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 26,
                                            color: Colors.redAccent,
                                          ),
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
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        FirebaseStorage.instance
                                                            // ignore: deprecated_member_use
                                                            .getReferenceFromUrl(
                                                              historyService
                                                                  .itemHistory[
                                                                      index]
                                                                  .imageURL,
                                                            )
                                                            .then((reference) =>
                                                                reference
                                                                    .delete())
                                                            .catchError((e) =>
                                                                print(e));
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
                                            padding:
                                                EdgeInsets.only(left: 12.0),
                                            child: Text(
                                              historyService
                                                  .itemHistory[index].message,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("yyyy年MM月dd日hh時mm分")
                                                .format(_date),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 12.0),
                                            child: Text(
                                              historyService
                                                      .itemHistory[index].price
                                                      .toStringAsFixed(0) +
                                                  '\円 ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          RaisedButton(
                                              color: Colors.black,
                                              splashColor: Colors.teal,
                                              child: Text(
                                                'カートに追加',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                Provider.of<OrderNotify>(
                                                        context,
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
                                                          CartPage()),
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
      ),
    );
  }
}
