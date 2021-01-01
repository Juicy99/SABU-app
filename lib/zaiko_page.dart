import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/order_notify.dart';

import 'auth_service.dart';
import 'order_notify.dart';

class ItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    historyService.dataPath1.orderBy("createAt").snapshots();
    final order = Provider.of<OrderNotify>(context);
    return ChangeNotifierProvider<OrderNotify>(
      create: (_) => OrderNotify()..getTodoListRealtime(),
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
          final cartHistory = model.itemHistory;
          return ListView(
            children: cartHistory
                .map(
                  (cart) => CheckboxListTile(
                    secondary: Image.network(
                      'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                      width: 70,
                    ),
                    title: Text(cart.name),
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
