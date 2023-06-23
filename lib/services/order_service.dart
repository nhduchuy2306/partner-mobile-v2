import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/order.dart';
import 'package:partner_mobile/models/order_request.dart';

class OrderService {
  static String baseUrl =
      "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<String> createOrder(OrderRequest orderRequest) async {
    var response = await http.post(Uri.parse('$baseUrl/orders/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(orderRequest.toJson()));
    if (response.statusCode == 200) {
      print('Order created successfully');
      return response.body;
    } else {
      print('Failed to create order');
      throw Exception('Failed to create order');
    }
  }

  static Future<List<Order>> getOrdersByUsername(String username) async {
    var response = await http.get(Uri.parse('$baseUrl/users/$username/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    List<Order> orders = [];
    if (response.statusCode == 200) {
      var ordersJson = json.decode(utf8.decode(response.bodyBytes));
      for (var orderJson in ordersJson) {
        orders.add(Order.fromJson(orderJson));
      }
      return orders;
    } else {
      print('Failed to retrieve orders');
      return orders;
    }
  }
}
