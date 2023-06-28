import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Product> _favoriteList = [];
  late SharedPreferences _prefs;

  List<Product> get favoriteList => _favoriteList;

  FavoriteProvider(){
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _favoriteList = jsonDecode(_prefs.getString('favoriteList') ?? '[]')
        .map<Product>((item) => Product.fromJson(item))
        .toList();
  }

  Future<void> _saveToPrefs() async {
    final favoriteData = jsonEncode(_favoriteList);
    await _prefs.setString('favoriteList', favoriteData);
  }

  void addFavorite(Product product) {
    if (_favoriteList.any((element) => element.productId == product.productId)) {
      _favoriteList.removeWhere((element) => element.productId == product.productId);
      _saveToPrefs();
    } else {
      _favoriteList.add(product);
      _saveToPrefs();
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteList.any((element) => element.productId == product.productId);
  }
}