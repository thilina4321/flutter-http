import 'package:flutter/material.dart';
import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/screen/edit_user_products_screen.dart';
import 'package:shop_app/screen/orders_screen.dart';
import 'package:shop_app/screen/splash_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

import './provider/products.dart';
import './screen/product_details.dart';
import './screen/product_overview_screen.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: null,
          update: (ctx, auth, products) {
            print(products);
            return Products(auth.token, auth.userId,
                products == null ? [] : products.items);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvide>(
          update: (ctx, auth, previous) => CartProvide(
              auth.token, previous == null ? [] : previous.cartItems),
          create: null,
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          update: (ctx, auth, previous) => UserProvider(auth.token, auth.userId,
              previous == null ? [] : previous.userFav),
          create: null,
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          update: (ctx, auth, previous) => Orders(
              auth.token, auth.userId, previous == null ? [] : previous.orders),
          create: null,
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authData, child) => MaterialApp(
          routes: {
            '/': (ctx) => authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authData.autoLoging(),
                    builder: (ctx, dataSnapshot) =>
                        dataSnapshot.connectionState == ConnectionState.waiting
                            ? SpashScreen()
                            : AuthScreen(),
                  ),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditUserProductScreen.routeName: (ctx) => EditUserProductScreen(),
          },
        ),
      ),
    );
  }
}
