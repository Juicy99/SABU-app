import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order.dart';

import 'cart_page.dart';
import 'order_notify.dart';

class ScreenOrder1 extends StatelessWidget {
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
                      "カート",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ],
                ),
                Text(
                  order.orderList.length.toString() + '点の商品がカートに入っています。',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
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
              child: TasksList1(),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "合計: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        order.orderList.length.toString() + "点",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        order.totalPriceAmount.toStringAsFixed(0) + "円",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      RaisedButton.icon(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("確認"),
                              content: Text(
                                  "合計金額を記録します。\n※カートはリセットされますが個数は記録されません。"),
                              actions: <Widget>[
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
                                  child: Text('登録'),
                                  onPressed: () {
                                    order.addTitle(order.totalPriceAmount);
                                    order.clearCart();
                                    return Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        color: Colors.redAccent,
                        label: Text(
                          '買取',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TasksList1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return Scaffold(
      body: ListView(
        children: order.orderList
            .map(
              (e) => Container(
                child: OrderCard1(e),
                key: Key(UniqueKey().toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderCard1 extends StatelessWidget {
  OrderList order;

  OrderCard1(this.order);
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<OrderNotify>(context, listen: false);
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
                  Image.network(order.imageURL),
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
                                      style: TextStyle(color: Colors.redAccent),
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
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  po.decrementQty(order);
                                },
                              ),
                              Text(
                                order.qty.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  po.incrementQty(order);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            (order.qty * order.price).toStringAsFixed(0) +
                                '\円 ',
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
    );
  }
}
