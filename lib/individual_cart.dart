import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IndividualCart extends StatelessWidget {
  @override
  String uid;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users/$uid/history/orderHistory')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Order.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.message),
        ),
      ),
    );
  }
}

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  DocumentReference reference;

  Order.fromMap(Map<String, dynamic> map(), {this.reference})
      : name = map()['name'],
        message = map()['message'],
        price = map()['price'],
        qty = map()['qty'];

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class IndividualCart2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the course document using a stream
    Stream<DocumentSnapshot> courseDocStream =
        FirebaseFirestore.instance.collection('orderHistory').doc().snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: courseDocStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // get course document
            var sections = snapshot.data['orderHistory'];

            // build list using names from sections
            return ListView.builder(
              itemCount: sections != null ? sections.length : 0,
              itemBuilder: (_, int index) {
                print(sections[index]()['itemHistory']);
                return ListTile(title: Text(sections[index]()['itemHistory']));
              },
            );
          } else {
            return Container();
          }
        });
  }
}
