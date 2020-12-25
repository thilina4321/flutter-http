import 'package:flutter/material.dart';
import 'package:shop_app/screen/cart_screen.dart';

class Badge extends StatelessWidget {
  final IconData icon;
  final int count;
  Badge({@required this.icon, this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: Icon(icon)),
        if (count > 0)
          Positioned(
            top: 5,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              child: Text(count.toString()),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
      ],
    );
  }
}
