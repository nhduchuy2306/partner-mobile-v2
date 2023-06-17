class Brand {
  int? brandId;
  String? brandName;
  bool? status;

  Brand({this.brandId, this.brandName, this.status});

  Brand.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['status'] = this.status;
    return data;
  }
}