import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetails extends StatelessWidget {
  static final routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(children: [
        Container(
          height: 300,
          width: double.infinity,
          child: Image.asset(
            'assets/images/three.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          product.description,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '\$ ${product.price.toStringAsFixed(2)}',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ]),
    );
  }
}
