import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/drawer.dart';
import '../provider/orders.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrder(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              print('waiting');
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Text('Error');
            }
            return Consumer<Orders>(builder: (context, orders, child) {
              return ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: Text(
                            '\$ ${orders.orders[index].price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                            ),
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    orders.orders[index].products.map((p) {
                                  return Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        child: Text(
                                          p.title,
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        child: Text(
                                          '${p.quantity.toString()} x',
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        elevation: 20,
                      ),
                    );
                  });
            });
          }),
    );
  }
}
