import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_card.dart';
import 'order_notify.dart';

class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    return Scaffold(
      body: ListView(
        children: order.items
            .map(
              (e) => Container(
                child: ItemCard(e),
                key: Key(UniqueKey().toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}
