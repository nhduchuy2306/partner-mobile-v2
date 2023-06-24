class PushNotification {
  String? subject;
  String? content;
  Data? data;
  String? image;
  String? token;

  PushNotification(
      {this.subject, this.content, this.data, this.image, this.token});

  PushNotification.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    content = json['content'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['content'] = this.content;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['image'] = this.image;
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  Data({this.additionalProp1, this.additionalProp2, this.additionalProp3});

  Data.fromJson(Map<String, dynamic> json) {
    additionalProp1 = json['additionalProp1'];
    additionalProp2 = json['additionalProp2'];
    additionalProp3 = json['additionalProp3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additionalProp1'] = this.additionalProp1;
    data['additionalProp2'] = this.additionalProp2;
    data['additionalProp3'] = this.additionalProp3;
    return data;
  }
}