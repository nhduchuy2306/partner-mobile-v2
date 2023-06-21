class OrderRequest {
  List<CartItems>? cartItems;
  String? userName;

  OrderRequest({this.cartItems, this.userName});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartItems != null) {
      data['cartItems'] = cartItems!.map((v) => v.toJson()).toList();
    }
    data['userName'] = userName;
    return data;
  }
}

class CartItems {
  int? productId;
  String? productName;
  String? productImage;
  int? quantity;
  double? price;

  CartItems(
      {this.productId,
      this.productName,
      this.productImage,
      this.quantity,
      this.price});

  CartItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['productImage'] = productImage;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}
