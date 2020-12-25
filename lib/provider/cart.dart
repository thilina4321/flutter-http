import 'package:flutter/material.dart';
import 'package:shop_app/model/cart.dart';

class CartProvide with ChangeNotifier {
  List<Cart> _cartItems = [];
  String token;
  CartProvide(this.token, this._cartItems);

  List<Cart> get cartItems {
    return [..._cartItems];
  }

  double get totalSum {
    double total = 0;
    _cartItems.forEach((item) {
      total += (item.price * item.quantity);
    });
    return total;
  }

  void addItemsToCart(id, title, price) {
    int existingIndex =
        _cartItems.indexWhere((item) => item.id == ValueKey(id));
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems
          .add(Cart(id: ValueKey(id), title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  void undoChange(id) {
    final product = _cartItems.firstWhere((item) => item.id == ValueKey(id));
    if (product.quantity > 1) {
      product.quantity -= 1;
    } else {
      _cartItems.removeWhere((item) => item.id == ValueKey(id));
    }
    notifyListeners();
  }
}
