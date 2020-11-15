import 'product.dart';

class Order {
  String name;
  String message;
  Product product;
  int qty = 1;
  double price;

  Order({this.product, this.qty, this.price, this.message, this.name});
}
