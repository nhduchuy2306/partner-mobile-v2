import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/customer_membership.dart';

class CustomerMemberShipService {
  static String baseUrl = "https://swd-back-end.azurewebsites.net/partner/api";

  static Future<CustomerMemberShip> getCustomerMemberShipById(String id) async {
    var url = Uri.parse("$baseUrl/members/information?customerId=$id");
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A"
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return CustomerMemberShip.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load customer');
    }
  }
}
