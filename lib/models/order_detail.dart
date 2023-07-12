class OrderDetail {
  int? detailId;
  int? orderId;
  double? price;
  int? quantity;
  int? productId;
  bool? status;
  String? productName;
  String? insuranceInfo;
  String? picture;

  OrderDetail(
      {this.detailId,
        this.orderId,
        this.price,
        this.quantity,
        this.productId,
        this.status,
        this.productName,
        this.insuranceInfo,
        this.picture});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    detailId = json['detailId'];
    orderId = json['orderId'];
    price = json['price'];
    quantity = json['quantity'];
    productId = json['productId'];
    status = json['status'];
    productName = json['productName'];
    insuranceInfo = json['insuranceInfo'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detailId'] = this.detailId;
    data['orderId'] = this.orderId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['productId'] = this.productId;
    data['status'] = this.status;
    data['productName'] = this.productName;
    data['insuranceInfo'] = this.insuranceInfo;
    data['picture'] = this.picture;
    return data;
  }
}