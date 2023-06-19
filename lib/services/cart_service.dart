import 'dart:convert';

import 'package:partner_mobile/models/cart_item.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static Future<void> addToCart(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    if (cartItems.isEmpty) {
      CartItem cartItem = CartItem(
          productId: product.productId,
          productName: product.productName,
          productImage: product.picture,
          quantity: 1,
          price: product.price);
      cartItems.add(cartItem);
    } else {
      bool isExist = false;
      for (CartItem cartItem in cartItems) {
        if (cartItem.productId == product.productId) {
          cartItem.quantity = cartItem.quantity! + 1;
          isExist = true;
          break;
        }
      }
      if (!isExist) {
        CartItem cartItem = CartItem(
            productId: product.productId,
            productName: product.productName,
            productImage: product.picture,
            quantity: 1,
            price: product.price);
        cartItems.add(cartItem);
      }
    }

    print(cartItems.length);

    prefs.setString('cartItems', jsonEncode(cartItems));
  }

  static Future<void> removeItemFromCart(int productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    cartItems.removeWhere((element) => element.productId == productId);

    if (cartItems.isEmpty) {
      prefs.remove('cartItems');
    } else {
      prefs.setString('cartItems', jsonEncode(cartItems));
    }
  }

  static Future<void> increaseProductQuantity(int productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    for (CartItem cartItem in cartItems) {
      if (cartItem.productId == productId) {
        cartItem.quantity = cartItem.quantity! + 1;
        break;
      }
    }

    prefs.setString('cartItems', jsonEncode(cartItems));
  }

  static Future<void> decreaseProductQuantity(int productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    for (CartItem cartItem in cartItems) {
      if (cartItem.productId == productId) {
        cartItem.quantity = cartItem.quantity! - 1;
        break;
      }
    }

    prefs.setString('cartItems', jsonEncode(cartItems));
  }

  static Future<List<CartItem>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    return cartItems;
  }

  static Future<int> getCartItemsCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CartItem> cartItems = jsonDecode(prefs.getString('cartItems') ?? '[]')
        .map<CartItem>((item) => CartItem.fromJson(item))
        .toList();

    return cartItems.length;
  }
}
