import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'individual_cart.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getHistoryRealtime(),
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
                    leading: Image.network(
                      'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                      width: 70,
                    ),
                    title: Text('\$${cart.total}'),
                    subtitle: Text(
                      DateFormat("yyyy年MM月dd日").format(cart.createdAt),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                    onTap: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndividualCart()),
                      );
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
