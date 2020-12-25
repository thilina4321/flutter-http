import 'package:flutter/cupertino.dart';

class Cart {
  var id;
  String title;
  int quantity;
  double price;

  Cart(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}
