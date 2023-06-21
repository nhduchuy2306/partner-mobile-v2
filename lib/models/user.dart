class User {
  String? username;
  String? fullName;
  String? address;
  String? password;
  String? email;
  String? phoneNumber;
  bool? status;
  String? gender;
  int? roleId;

  User(
      {this.username,
      this.fullName,
      this.address,
      this.password,
      this.email,
      this.phoneNumber,
      this.status,
      this.gender,
      this.roleId});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    fullName = json['fullName'];
    address = json['address'];
    password = json['password'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    gender = json['gender'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['status'] = this.status;
    data['gender'] = this.gender;
    data['roleId'] = this.roleId;
    return data;
  }
}
