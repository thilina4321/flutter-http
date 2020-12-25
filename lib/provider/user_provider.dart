import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/favourite.dart';

class UserProvider with ChangeNotifier {
  String userId;
  String token;
  List<Favourite> _userFav = [];

  UserProvider(this.token, this.userId, this._userFav);

  List get userFav {
    return [..._userFav];
  }

  Future<void> changeFavStatus(id) async {
    var isFav = false;
    final url =
        'https://flutter-shop-app-7823f.firebaseio.com/userFav/$userId/$id.json?auth=$token';

    int favProIndex = _userFav.indexWhere((f) => f == id);
    if (favProIndex >= 0) {
      final fav = await http.get(url);
      print(json.decode(fav.body));
    } else {
      isFav = true;
      _userFav.add(Favourite(id: id, favStatus: isFav));
      await http.put(url, body: json.encode(isFav));
    }
  }
}
