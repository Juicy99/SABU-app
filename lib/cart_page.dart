import 'package:flutter/material.dart';

import 'individual_cart.dart';

class CartPage extends StatelessWidget {
  final carts = [
    '日付',
    'アイテム2',
    'アイテム3',
    'アイテム4',
    'アイテム5',
    'アイテム6',
    'アイテム7',
    'アイテム8',
    'アイテム9',
    'アイテム10',
    'アイテム11',
    'アイテム12',
    'アイテム13',
    'アイテム14',
    'アイテム15',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('買取履歴'),
      ),
      body: ListView.separated(
        itemCount: carts.length,
        itemBuilder: (context, int position) {
          return Card(
            child: ListTile(
              leading: Image.network(
                'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg',
                width: 70,
              ),
              title: Text(carts[position]),
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
                  MaterialPageRoute(builder: (context) => IndividualCart()),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, _) => const Divider(),
      ),
    );
  }
}
