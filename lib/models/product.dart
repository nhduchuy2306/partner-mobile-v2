import 'dart:ffi';

class Product {
  int? productId;
  String? productName;
  double? price;
  int? quantity;
  String? insuranceInfo;
  String? picture;
  bool? status;
  int? categoryId;
  int? brandId;

  Product(
      {this.productId,
        this.productName,
        this.price,
        this.quantity,
        this.insuranceInfo,
        this.picture,
        this.status,
        this.categoryId,
        this.brandId});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    price = json['price'];
    quantity = json['quantity'];
    insuranceInfo = json['insuranceInfo'];
    picture = json['picture'];
    status = json['status'];
    categoryId = json['categoryId'];
    brandId = json['brandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['insuranceInfo'] = this.insuranceInfo;
    data['picture'] = this.picture;
    data['status'] = this.status;
    data['categoryId'] = this.categoryId;
    data['brandId'] = this.brandId;
    return data;
  }
}