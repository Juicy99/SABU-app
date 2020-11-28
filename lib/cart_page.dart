import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getTodoListRealtime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('買取履歴'),
        ),
        body: Consumer<OrderNotify>(builder: (context, model, child) {
          final cartHistory = model.cartHistory;
          return ListView(
            children: cartHistory
                .map(
                  (cart) => ListTile(
                    title: Text(cart.title),
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
