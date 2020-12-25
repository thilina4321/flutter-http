import 'package:shop_app/model/cart.dart';

class Order {
  String id;
  double price;
  List<Cart> products;

  Order({this.id, this.price, this.products});
}
