class UserInfo {
  String? displayName;
  String? email;
  String? phoneNumber;
  String? photoURL;
  String? providerId;
  String? uid;

  UserInfo(
      {this.displayName,
      this.email,
      this.phoneNumber,
      this.photoURL,
      this.providerId,
      this.uid});

  UserInfo.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    photoURL = json['photoURL'];
    providerId = json['providerId'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['photoURL'] = this.photoURL;
    data['providerId'] = this.providerId;
    data['uid'] = this.uid;
    return data;
  }
}
