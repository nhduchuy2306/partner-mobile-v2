import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/push_notification.dart';

class PushNotificationService {
  static String baseUrl =
      "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<String> createNotification(
      PushNotification pushNotification) async {
    var response = await http.post(Uri.parse('$baseUrl/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pushNotification.toJson()));
    if (response.statusCode == 200) {
      print('Push notification sent successfully');
      return response.body;
    } else {
      print('Failed to push notification');
      throw Exception('Failed to push notification');
    }
  }
}
