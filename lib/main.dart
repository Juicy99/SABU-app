import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'add_task_screen.dart';
import 'auth_service.dart';
import 'home.dart';
import 'individual_cart.dart';
import 'order_notify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    // providerを複数使うときはMultiProviderを使う。
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService.instance()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => OrderNotify()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => OrderNotify(),
      child: MaterialApp(
        home: SignProcess(),
      ),
    );
  }
}

// 本番かリリースかを判断するには bool.fromEnvironment('dart.vm.product')を使う。
// よりわかりやすくするためにラップして使っている。
bool isRelease() {
  bool _bool;
  bool.fromEnvironment('dart.vm.product') ? _bool = true : _bool = false;
  return _bool;
}

class SignProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AuthService authService, _) {
        // ログインの状態に応じて処理を遷移させる。
        switch (authService.status) {
          case Status.uninitialized:
            print('uninitialized');
            return Center(child: CircularProgressIndicator());
          case Status.unauthenticated:
          case Status.authenticating:
            print('anonymously');
            authService.signInAnonymously();
            return Center(child: CircularProgressIndicator());
          case Status.authenticated:
            print("authenticated");
            break; // DbProcess();へ進む

        }
        return MyHomePage();
      },
    );
  }
}

class DbProcess extends StatelessWidget {
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
            return ViewPage();
        }
      },
    );
  }
}

class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyService = Provider.of<OrderNotify>(context);

    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text('買取履歴\n(${isRelease() ? 'リリース' : 'デバック'}モード)'))),
      body: Center(
        child: ListView.builder(
          itemCount: historyService.history.length,
          itemBuilder: (BuildContext context, int index) {
            final _date = historyService.history[index].createAt.toDate();
            return ListTile(
              leading: Image.network(
                'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                width: 70,
              ),
              title: GestureDetector(
                onTap: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndividualCart()),
                  );
                },
                child: Text(
                    '${historyService.history[index].total.toStringAsFixed(0)}円'),
              ),
              subtitle: Text(
                DateFormat("yyyy年MM月dd日hh時mm分").format(_date),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  historyService
                      .deleteDocument(historyService.history[index].docId);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
      ),
    );
  }
}

class NameInputDialog extends StatefulWidget {
  @override
  _NameInputDialogState createState() => _NameInputDialogState();
}

class _NameInputDialogState extends State<NameInputDialog> {
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    return AlertDialog(
      title: Text('予定を入力してください'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('クリア'),
          onPressed: _nameController.clear,
        ),
        FlatButton(
          child: Text('決定'),
          onPressed: () {
            cartService.addTitle(_nameController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
