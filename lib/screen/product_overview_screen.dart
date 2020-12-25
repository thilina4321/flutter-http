import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/widget/badge.dart';
import 'package:shop_app/widget/drawer.dart';

import '../model/product.dart';
import '../provider/products.dart';
import '../widget/product_item.dart';

enum FilterPopUp { favourite, all }

class ProductOverviewScreen extends StatefulWidget {
  static String routeName = 'product-overview';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isFav = false;
  bool isLoading = true;
  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((value) => isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> loadedProducts = isFav
        ? Provider.of<Products>(context).favItems
        : Provider.of<Products>(context).items;
    List cartItems = Provider.of<CartProvide>(context).cartItems;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Badge(
            icon: Icons.shopping_cart,
            count: cartItems.length,
          ),
          PopupMenuButton(onSelected: (selectedValue) {
            setState(() {
              if (selectedValue == FilterPopUp.favourite) {
                isFav = true;
              } else {
                isFav = false;
              }
            });
          }, itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                value: FilterPopUp.favourite,
                child: Text('Favourite'),
              ),
              PopupMenuItem(
                value: FilterPopUp.all,
                child: Text('All'),
              ),
            ];
          }),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: loadedProducts.length,
              itemBuilder: (ctx, index) {
                return ProductItem(
                  loadedProducts[index].id,
                );
              }),
    );
  }
}
