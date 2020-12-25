import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireIn;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  // String get token {
  //   if (_expireIn != null &&
  //       _expireIn.isAfter(DateTime.now()) &&
  //       _token != null) {
  //     return _token;
  //   }
  //   return null;
  // }

  Future<void> signup(email, password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBWIfREKhppuzGr5w77nSIw0BfgZJzqibo';

    try {
      final respond = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      if (json.decode(respond.body)['error'] != null) {
        print(json.decode(respond.body)['error']['message']);

        throw HttpException(json.decode(respond.body)['error']['message']);
      }
      var successData = json.decode(respond.body);
      _token = successData['idToken'];
      _userId = successData['localId'];
      _expireIn = DateTime.now().add(
        Duration(
          seconds: int.parse(successData['expiresIn']),
        ),
      );
      final prefes = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
      });
      prefes.setString('token', userData);

      notifyListeners();
    } catch (e) {
      throw e;
    }

    // print(json.decode(respond.body));
    // print(respond.statusCode);
  }

  Future<void> signin(email, password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBWIfREKhppuzGr5w77nSIw0BfgZJzqibo';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      if (json.decode(response.body)['error'] != null) {
        print(json.decode(response.body)['error']['message']);
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      var successData = json.decode(response.body);
      _token = successData['idToken'];
      _userId = successData['localId'];
      _expireIn = DateTime.now().add(
        Duration(
          seconds: int.parse(successData['expiresIn']),
        ),
      );
      final prefes = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
      });

      prefes.setString('token', userData);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void logout() {
    _userId = null;
    _expireIn = null;
    _token = null;

    notifyListeners();
  }

  Future<bool> autoLoging() async {
    final prefes = await SharedPreferences.getInstance();
    if (!prefes.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefes.getString('token'));
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    notifyListeners();
    return true;
  }
}
