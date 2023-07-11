import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/user.dart';
import 'package:partner_mobile/models/user_info.dart';

class UserService {
  static const baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<User?> register(UserInfo userInfo) async {
    var response = await http.post(Uri.parse('$baseUrl/users/google/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(userInfo.toJson()));

    if (response.statusCode == 201) {
      print('User registered successfully');
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      print('User already exists');
      return null;
    }
  }

  static Future<User?> getUserByUsername(String username) async {
    var response = await http
        .get(Uri.parse('$baseUrl/users/$username'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('User retrieved successfully');
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      print('User not found');
      return null;
    }
  }
}
