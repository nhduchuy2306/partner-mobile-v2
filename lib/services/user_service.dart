import 'package:http/http.dart' as http;

class User {
  int? id;
  String? userName;
  String? fullName;
  String? code;
  String? email;
  String? image;
  String? phone;
  String? address;
  bool? state;
  bool? status;

  User(
      {this.id,
      this.userName,
      this.fullName,
      this.code,
      this.email,
      this.image,
      this.phone,
      this.address,
      this.state,
      this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    code = json['code'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    address = json['address'];
    state = json['state'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['code'] = this.code;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['state'] = this.state;
    data['status'] = this.status;
    return data;
  }
}

Future<dynamic> fetchUser() async {
  final response = await http
      .get(Uri.parse('https://swd-back-end.azurewebsites.net/api/partners'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
