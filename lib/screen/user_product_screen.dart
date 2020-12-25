import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screen/edit_user_products_screen.dart';
import 'package:shop_app/widget/drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditUserProductScreen.routeName);
              })
        ],
        title: Text('Your products'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(true)
              .then((value) => null);
        },
        child: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(true),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error != null) {
              return Text('Error');
            }
            return Consumer<Products>(builder: (context, product, child) {
              return ListView.builder(
                  itemCount: product.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        UserProductItem(
                            product.items[index].id,
                            product.items[index].title,
                            product.items[index].imageUrl),
                        Divider(),
                      ],
                    );
                  });
            });
          },
        ),
      ),
    );
  }
}
