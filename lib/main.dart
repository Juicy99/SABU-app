import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/auth_service.dart';
import 'package:sateiv2_app/home.dart';
import 'package:sateiv2_app/provider/order_notify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService.instance()),
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

class SignProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AuthService authService, _) {
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
            break;
        }
        return DbProcess();
      },
    );
  }
}

class DbProcess extends StatelessWidget {
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
            return MyHomePage();
        }
      },
    );
  }
}
