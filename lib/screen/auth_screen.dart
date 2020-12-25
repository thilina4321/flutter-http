import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/auth.dart';
import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/screen/product_overview_screen.dart';

enum AuthMode {
  signup,
  login,
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var passwordFocusNode = FocusNode();
  var signDetails = Auth(email: '', password: '');
  var authMode = AuthMode.signup;
  final passwordController = TextEditingController();

  @override
  void initState() {
    passwordFocusNode.addListener(updateListner);
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.removeListener(updateListner);
    passwordFocusNode.dispose();
    passwordController.dispose();
    super.dispose();
  }

  updateListner() {
    if (!passwordFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void changeAuthMode() {
    if (authMode == AuthMode.signup) {
      setState(() {
        authMode = AuthMode.login;
      });
    } else {
      setState(() {
        authMode = AuthMode.signup;
      });
    }
  }

  void _saveData() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    try {
      if (authMode == AuthMode.signup) {
        print('signUp');

        await Provider.of<AuthProvider>(context, listen: false)
            .signup(signDetails.email, signDetails.password);
      } else if (authMode == AuthMode.login) {
        print('login');
        await Provider.of<AuthProvider>(context, listen: false)
            .signin(signDetails.email, signDetails.password);
        // Navigator.of(context)
        //     .pushReplacementNamed(ProductOverviewScreen.routeName);
      }
    } catch (e) {
      var errorMessage = 'Please try ageing later';
      if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email not found';
      } else if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email alreadt taken';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      print(errorMessage);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(errorMessage.toString()),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Card(
          elevation: 3,
          child: ListView(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            children: [
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    signDetails.email = val;
                  });
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: passwordController,
                onSaved: (val) {
                  setState(() {
                    signDetails.password = val;
                  });
                },
                textInputAction: TextInputAction.next,
                focusNode: passwordFocusNode,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              if (authMode == AuthMode.signup)
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please Enter Password';
                    }
                    if (val != passwordController.text) {
                      return 'Password not matched';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
              RaisedButton(
                color: Colors.blue,
                onPressed: _saveData,
                child: Text(
                  authMode == AuthMode.signup ? 'Register' : 'Log In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  changeAuthMode();
                },
                child: Text(
                  authMode != AuthMode.signup ? 'Sign up' : 'log in',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
