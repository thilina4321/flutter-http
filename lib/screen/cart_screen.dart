import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/screen/orders_screen.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final total = Provider.of<CartProvide>(context).totalSum;
    final items = Provider.of<CartProvide>(context).cartItems;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          total.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        await Provider.of<Orders>(context, listen: false)
                            .addOrder(total, items);
                        Provider.of<CartProvide>(context, listen: false)
                            .clearCart();
                        Navigator.of(context)
                            .pushReplacementNamed(OrderScreen.routeName);
                      },
                      child: Text('ORDER NOW'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      key: ValueKey(items[index].id),
                      background: Container(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        color: Colors.red,
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                    'Do you really want to delete the item'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('No'),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            });
                      },
                      onDismissed: (direction) {
                        Provider.of<CartProvide>(context, listen: false)
                            .removeItem(index);
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.purple,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                  child: Text(
                                      items[index].price.toStringAsFixed(1))),
                            ),
                          ),
                          title: Text(items[index].title),
                          trailing: Text(
                            '${items[index].quantity.toString()} X',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
