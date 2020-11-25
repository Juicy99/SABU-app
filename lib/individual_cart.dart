import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order.dart';
import 'order_notify.dart';

class IndividualCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 20.0, left: 30.0, right: 30.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      "日付",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "合計: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      order.items.length.toString() + "点",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      Provider.of<OrderNotify>(context)
                              .totalCartValue
                              .toString() +
                          "円",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TasksList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getTodoListRealtime(),
      child: Scaffold(
        body: ListView(
          children: order.items
              .map(
                (e) => Container(
                  child: OrderCard(e),
                  key: Key(UniqueKey().toString()),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  Order order;

  OrderCard(this.order);
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<OrderNotify>(context, listen: false);
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getTodoListRealtime(),
      child: Container(
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
                    Image.network(
                        'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg'),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 100) / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 1.0),
                          width: 150,
                          child: Text(
                            order.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        po.removeOrder(order);
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              order.message,
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  order.qty.toString() + "個",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              (order.qty * order.price).toString() + '\円 ',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
