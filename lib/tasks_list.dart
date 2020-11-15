import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_card.dart';
import 'order_notify.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return Scaffold(
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
    );
  }
}
