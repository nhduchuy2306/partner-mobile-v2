class ProductPicture {
  int? pictureId;
  String? pictureUrl;
  bool? status;
  int? productId;

  ProductPicture(
      {this.pictureId, this.pictureUrl, this.status, this.productId});

  ProductPicture.fromJson(Map<String, dynamic> json) {
    pictureId = json['pictureId'];
    pictureUrl = json['pictureUrl'];
    status = json['status'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pictureId'] = this.pictureId;
    data['pictureUrl'] = this.pictureUrl;
    data['status'] = this.status;
    data['productId'] = this.productId;
    return data;
  }
}