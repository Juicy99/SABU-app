import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'auth_service.dart';
import 'main.dart';
import 'order_notify.dart';

class ItemPage extends StatelessWidget {
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
                    return ListTile(
                      leading: Image.network(
                        'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                        width: 70,
                      ),
                      title: Text(historyService.itemHistory[index].name),
                      subtitle: Text(
                        DateFormat("yyyy年MM月dd日hh時mm分").format(_date),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          historyService.deleteDocument2(
                              historyService.itemHistory[index].docId);
                        },
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
