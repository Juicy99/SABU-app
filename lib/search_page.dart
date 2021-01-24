import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'auth_service.dart';
import 'order_notify.dart';

class SearchPage1 extends StatefulWidget {
  @override
  _SearchPageState1 createState() => _SearchPageState1();
}

class _SearchPageState1 extends State<SearchPage1> {
  String name = "";
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
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Card(
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search), hintText: 'Search...'),
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
                        .where("name", isEqualTo: name)
                        .snapshots()
                    : historyService.dataPath1.snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot data = snapshot.data.docs[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Text(data['name']),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            );
        }
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller;
  bool isCaseSensitive = false;



  final List<String> searchTargets =
      List.generate(10, (index) => 'Something ${index + 1}');

  List<String> searchResults = [];

  void search(String query, {bool isCaseSensitive = false}) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    final List<String> hitItems = searchTargets.where((element) {
      if (isCaseSensitive) {
        return element.contains(query);
      }
      return element.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = hitItems;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Items'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Case Sensitive'),
              value: isCaseSensitive,
              onChanged: (bool newVal) {
                setState(() {
                  isCaseSensitive = newVal;
                });
                search(controller.text, isCaseSensitive: newVal);
              },
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter keyword'),
              onChanged: (String val) {
                search(val, isCaseSensitive: isCaseSensitive);
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: HighlightedText(
                    wholeString: searchResults[index],
                    highlightedString: controller.text,
                    isCaseSensitive: isCaseSensitive,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  HighlightedText({
    @required this.wholeString,
    @required this.highlightedString,
    this.defaultStyle = const TextStyle(color: Colors.black),
    this.highlightStyle = const TextStyle(color: Colors.blue),
    this.isCaseSensitive = false,
  });

  final String wholeString;
  final String highlightedString;
  final TextStyle defaultStyle;
  final TextStyle highlightStyle;
  final bool isCaseSensitive;

  int get _highlightStart {
    if (isCaseSensitive) {
      return wholeString.indexOf(highlightedString);
    }
    return wholeString.toLowerCase().indexOf(highlightedString.toLowerCase());
  }

  int get _highlightEnd => _highlightStart + highlightedString.length;

  @override
  Widget build(BuildContext context) {
    // indexOf()は該当する要素が見つからない場合「-1」を返す。
    // 検索キーワードを含んでいないので、ハイライトされていない素のテキストを表示。
    if (_highlightStart == -1) {
      return Text(wholeString, style: defaultStyle);
    }
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(text: wholeString.substring(0, _highlightStart)),
          TextSpan(
            text: wholeString.substring(_highlightStart, _highlightEnd),
            style: highlightStyle,
          ),
          TextSpan(text: wholeString.substring(_highlightEnd))
        ],
      ),
    );
  }
}
