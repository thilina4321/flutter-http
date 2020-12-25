import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/model/cart.dart';
import 'package:shop_app/model/order.dart';

import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  String token;
  String userId;
  Orders(this.token, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(price, List<Cart> products) async {
    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/orders.json?auth=$token';
    try {
      final order = await http.post(url,
          body: json.encode({
            'createrId': userId,
            'price': price,
            'proucts': products
                .map((e) => {
                      'price': e.price,
                      'quantity': e.quantity,
                      'title': e.title,
                    })
                .toList()
          }));
      print(json.decode(order.body));
      _orders.insert(
        0,
        Order(
          id: json.decode(order.body)['name'],
          price: price,
          products: products,
        ),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchOrder() async {
    final filter = 'orderBy="createrId"&equalTo="$userId"';

    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/orders.json?auth=$token&$filter';
    try {
      List<Order> fecthOrders = [];
      final order = await http.get(url);
      final orderData = json.decode(order.body) as Map<String, dynamic>;
      orderData.forEach((key, value) {
        fecthOrders.add(
          Order(
            id: key,
            price: value['price'],
            // products: (value['proucts']) as List<Cart>
            products: (value['proucts'] as List).map((e) {
              return Cart(
                  price: e['price'],
                  id: e['id'],
                  quantity: e['quantity'],
                  title: e['title']);
            }).toList(),
          ),
        );
      });
      _orders = fecthOrders;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
