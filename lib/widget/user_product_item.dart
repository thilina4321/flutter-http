import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screen/edit_user_products_screen.dart';

class UserProductItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String id;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        title: Text(widget.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        EditUserProductScreen.routeName,
                        arguments: widget.id);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(widget.id)
                        .catchError((error) {
                      setState(() {
                        scaffold.hideCurrentSnackBar();
                        scaffold.showSnackBar(SnackBar(
                          content: Text('Delete faild'),
                          duration: Duration(seconds: 2),
                        ));
                      });
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
