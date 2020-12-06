import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'individual_cart.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getHistoryRealtime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('買取履歴'),
          actions: [
            Consumer<OrderNotify>(builder: (context, order, child) {
              final isActive = order.checkShouldActiveCompleteButton();
              return FlatButton(
                onPressed: isActive
                    ? () async {
                        await order.deleteCheckedItems();
                      }
                    : null,
                child: Text(
                  '完了',
                  style: TextStyle(
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                ),
              );
            })
          ],
        ),
        body: Consumer<OrderNotify>(builder: (context, model, child) {
          final cartHistory = model.cartHistory;
          return ListView(
            children: cartHistory
                .map(
                  (cart) => CheckboxListTile(
                    secondary: Image.network(
                      'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                      width: 70,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndividualCart()),
                        );
                      },
                      child: Text('${cart.total}円'),
                    ),
                    subtitle: Text(
                      DateFormat("yyyy年MM月dd日").format(cart.createdAt),
                    ),
                    value: cart.isDone,
                    onChanged: (bool value) {
                      cart.isDone = !cart.isDone;
                      order.reload();
                    },
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
