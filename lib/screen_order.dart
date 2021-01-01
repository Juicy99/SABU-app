import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'order_notify.dart';
import 'tasks_list.dart';

class ScreenOrder extends StatelessWidget {
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
                  order.items.length.toString() + '点の商品がカートに入っています。',
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
              child: TasksList(),
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
                        order.items.length.toString() + "点",
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
