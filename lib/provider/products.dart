import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  String token;
  String userId;
  Products(this.token, this.userId, this._items); //
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   isFavourite: false,
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p2',
    //     isFavourite: false,
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://cf.bstatic.com/images/hotel/max1024x768/305/30538491.jpg'),
    // Product(
    //   id: 'p3',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   isFavourite: false,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p4',
    //     isFavourite: false,
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://cf.bstatic.com/images/hotel/max1024x768/305/30538491.jpg'),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((pro) => pro.isFavourite).toList();
  }

  Product findById(productId) {
    return _items.firstWhere((pro) => pro.id == productId);
  }

  Future<void> addProduct(Product product) async {
    final String url =
        'https://flutter-shop-app-7823f.firebaseio.com/products.json?auth=$token';

    try {
      final res = await http.post(url,
          body: json.encode({
            'createrId': userId,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          }));

      final newProduct = Product(
        id: json.decode(res.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetProducts([bool isFilterProduct = false]) async {
    final filterData =
        isFilterProduct ? 'orderBy="createrId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/products.json?auth=$token&$filterData';
    try {
      print(url);
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            price: value['price'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            isFavourite: value['isFavourite']));
        _items = loadedProducts;
        notifyListeners();
        print(3);
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((item) => item.id == id);
    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/products/$id.json?auth=$token';
    try {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      _items[productIndex] = product;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(id) async {
    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/products/$id.json?auth=$token';
    try {
      final res = await http.delete(url);
      _items.removeWhere((item) => item.id == id);
      if (res.statusCode == 405) {
        throw Error();
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> changeFavStatus(id) async {
    final product = _items.firstWhere((pro) => pro.id == id);
    product.isFavourite = !product.isFavourite;

    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/userFav/$userId/$id.json?auth=$token';
    try {
      await http.put(url, body: json.encode(product.isFavourite));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
