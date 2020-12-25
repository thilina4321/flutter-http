import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/screen/product_details.dart';

class ProductItem extends StatelessWidget {
  final String id;

  ProductItem(this.id);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              color: Colors.deepOrange,
              onPressed: () {
                Provider.of<CartProvide>(context, listen: false)
                    .addItemsToCart(id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item added to cart!'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        Provider.of<CartProvide>(context, listen: false)
                            .undoChange(id);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<UserProvider>(context, listen: false)
                        .changeFavStatus(id);
                  } catch (e) {}
                },
                color: Colors.deepOrange,
                icon: Provider.of<Products>(context).findById(id).isFavourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_outline)),
          ),
        ),
      ),
    );
  }
}
