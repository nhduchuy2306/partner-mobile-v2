import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/push_notification.dart';

class PushNotificationService {
  static String baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<String> createOrder(PushNotification pushNotification) async {
    var response = await http.post(Uri.parse('$baseUrl/notification/send-notification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pushNotification.toJson()));
    if (response.statusCode == 200) {
      print('Order created successfully');
      return response.body;
    } else {
      print('Failed to create order');
      throw Exception('Failed to create order');
    }
  }
}