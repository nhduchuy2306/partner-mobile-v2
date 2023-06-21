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

  void clearCart() {
    _cartItems.clear();
    _prefs.remove('cartItems');
    notifyListeners();
  }

  void addToCart(Product productModel, int quantity) {
    if (_cartItems
        .any((item) => item.product?.productId == productModel.productId)) {
      final cartItem = _cartItems.firstWhere(
          (item) => item.product?.productId == productModel.productId);
      if (quantity == 1) {
        cartItem.quantity = cartItem.quantity! + 1;
      } else {
        cartItem.quantity = cartItem.quantity! + quantity;
      }
      _saveToPrefs();
      notifyListeners();
      return;
    } else {
      final cartItem = CartItem(
        product: productModel,
        quantity: quantity,
      );
      _cartItems.add(cartItem);
      _saveToPrefs();
      notifyListeners();

      return;
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product?.productId == productId);
    if (_cartItems.isEmpty) {
      _prefs.remove('cartItems');
      _saveToPrefs();
    } else {
      _saveToPrefs();
    }
    notifyListeners();
  }

  int get numItemsInCart => _cartItems.length;

  void increaseCartItemQuantity(int productId) {
    final cartItem =
        _cartItems.firstWhere((item) => item.product?.productId == productId);
    cartItem.quantity = cartItem.quantity! + 1;
    _saveToPrefs();
    notifyListeners();
  }

  void decreaseCartItemQuantity(int productId) {
    final cartItem =
        _cartItems.firstWhere((item) => item.product?.productId == productId);
    cartItem.quantity = cartItem.quantity! - 1;
    _saveToPrefs();
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      total += item.product!.price! * item.quantity!;
    }
    return total;
  }
}
