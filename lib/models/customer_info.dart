class CustomerInfo {
  String? customerId;
  String? fullName;
  String? email;
  String? dob;
  String? image;
  String? phone;

  CustomerInfo(
      {this.customerId,
      this.fullName,
      this.email,
      this.dob,
      this.image,
      this.phone});

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    fullName = json['fullName'];
    email = json['email'];
    dob = json['dob'];
    image = json['image'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['phone'] = this.phone;
    return data;
  }
}
