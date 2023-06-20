import 'package:partner_mobile/models/product.dart';

class CartItem {
  Product? product;
  int? quantity;

  CartItem({
    this.product,
    this.quantity,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = product;
    data['quantity'] = quantity;
    return data;
  }
}
