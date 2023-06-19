class CartItem {
  int? productId;
  String? productName;
  String? productImage;
  int? quantity;
  double? price;

  CartItem({
    this.productId,
    this.productName,
    this.productImage,
    this.quantity,
    this.price,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = productId;
    data['productName'] = productName;
    data['productImage'] = productImage;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}
