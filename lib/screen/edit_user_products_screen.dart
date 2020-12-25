import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screen/user_product_screen.dart';

class EditUserProductScreen extends StatefulWidget {
  static String routeName = '/edit-produts';

  @override
  _EditUserProductScreenState createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  final imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var editingProduct = Product(
      id: null, title: null, description: null, price: 0, imageUrl: null);

  bool isFirst = true;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      final productId = ModalRoute.of(context).settings.arguments;

      if (productId != null) {
        editingProduct = Provider.of<Products>(context)
            .items
            .firstWhere((item) => item.id == productId);
        imageController.text = editingProduct.imageUrl;
      }
    }

    isFirst = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editingProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editingProduct);
      } catch (e) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Some thing went wrong'),
                content: Text('Please come againg later'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context)
                            .pushNamed(UserProductsScreen.routeName);
                      },
                      child: Text('Okey')),
                ],
              );
            });
      } finally {
        setState(() {
          isLoading = false;
          Navigator.of(context).pop();
        });
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editingProduct.id, editingProduct);
      Navigator.of(context).pushNamed(UserProductsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      editingProduct = Product(
                          id: editingProduct.id,
                          title: val,
                          description: null,
                          price: null,
                          imageUrl: null);
                    },
                    initialValue: editingProduct.title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    initialValue: editingProduct.price.toString(),
                    onSaved: (val) {
                      editingProduct = Product(
                          id: editingProduct.id,
                          title: editingProduct.title,
                          description: null,
                          price: double.parse(val),
                          imageUrl: null);
                    },
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter a price';
                      } else if (double.tryParse(val) == null) {
                        return 'Enter valid number';
                      } else if (double.parse(val) <= 0) {
                        return 'Enter positive number';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onSaved: (val) {
                            editingProduct = Product(
                                id: editingProduct.id,
                                title: editingProduct.title,
                                description: null,
                                price: editingProduct.price,
                                imageUrl: val);
                          },
                          textInputAction: TextInputAction.next,
                          controller: imageController,
                          keyboardType: TextInputType.url,
                          onFieldSubmitted: (_) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: 'Url',
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Please enter a url';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        height: 100,
                        width: 100,
                        child: imageController.text.isEmpty
                            ? Text('Enter the image')
                            : Image.network(
                                imageController.text,
                                fit: BoxFit.cover,
                              ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: editingProduct.description,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      editingProduct = Product(
                          id: editingProduct.id,
                          title: editingProduct.title,
                          description: val,
                          price: editingProduct.price,
                          imageUrl: editingProduct.imageUrl);
                    },
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
    );
  }
}
