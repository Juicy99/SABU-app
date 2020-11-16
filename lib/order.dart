import 'product.dart';

class Order {
  String name;
  String message;
  int qty = 1;
  double price;
  Product product;

  Order({this.qty, this.product, this.price, this.message, this.name});
}
