import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:partner_mobile/models/cart_item.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  late SharedPreferences _prefs;

  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    _cartItems = jsonDecode(_prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();
  }

  Future<void> _saveToPrefs() async {
    final cartData = jsonEncode(_cartItems);
    await _prefs.setString('cartItems', cartData);
  }

  void addToCart(Product product) {
    if (_cartItems.any((item) => item.productId == product.productId)) {
      final cartItem = _cartItems.firstWhere((item) => item.productId == product.productId);
      cartItem.quantity = cartItem.quantity! + 1;
      _saveToPrefs();
      notifyListeners();

      print('Cart Item: ${cartItem.quantity}');
      print('Cart Name: ${cartItem.productName}');
      print('Cart length: ${_cartItems.length}');
      return;
    }
    else{
      final cartItem = CartItem(
        productId: product.productId,
        productName: product.productName,
        productImage: product.picture,
        price: product.price,
        quantity: 1,
      );
      _cartItems.add(cartItem);
      _saveToPrefs();
      notifyListeners();

      print('Cart Item: ${cartItem.quantity}');
      print('Cart Name: ${cartItem.productName}');
      return;
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    if(_cartItems.isEmpty){
      _prefs.remove('cartItems');
      _saveToPrefs();
    }
    else{
      _saveToPrefs();
    }
    notifyListeners();
  }

  int get numItemsInCart => _cartItems.length;
}