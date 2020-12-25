import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/auth.dart';
import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/screen/orders_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text('Hello customer'),
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(
                Icons.shop_rounded,
                color: Colors.green,
                size: 25,
              ),
            ),
            label: Text(
              'Shop',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Divider(),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(
                Icons.payment,
                color: Colors.green,
                size: 25,
              ),
            ),
            label: Text(
              'Orders',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Divider(),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(
                Icons.edit,
                color: Colors.green,
                size: 25,
              ),
            ),
            label: Text(
              'Manage Users',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Divider(),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context).logout();
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.green,
                size: 25,
              ),
            ),
            label: Text(
              'Log out',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
