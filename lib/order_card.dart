import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order.dart';
import 'order_notify.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  Order order;

  OrderCard(this.order);
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<OrderNotify>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                    order.imageURL,
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace stackTrace) {
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
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 26, color: Colors.white),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Colors.white),
                                onPressed: () {
                                  po.decrementQty(order);
                                },
                              ),
                              Text(
                                order.qty.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Colors.white),
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
                                color: Colors.white,
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
            Consumer<OrderNotify>(builder: (context, model, child) {
              return model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
