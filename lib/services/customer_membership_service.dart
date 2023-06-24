import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/customer_info.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/partner_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerMemberShipService {
  static String baseUrl = "https://swd-back-end.azurewebsites.net/partner/api";

  static Future<CustomerMemberShip> getCustomerMemberShipById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var url = Uri.parse("$baseUrl/members/information?customerId=$id");
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization":
          "Bearer ${partnerTokenFromAdmin ?? 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A'}"
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return CustomerMemberShip.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load customer');
    }
  }

  static Future<String> getTokenOfPartner(PartnerToken partnerToken) async {
    var response = await http.post(Uri.parse('$baseUrl/programs/token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(partnerToken.toJson()));
    if (response.statusCode == 200) {
      print('Token created successfully');
      return response.body;
    } else {
      print('Failed to create token');
      throw Exception('Failed to create token');
    }
  }

  static Future<void> registerCustomer(CustomerInfo customerInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var url = Uri.parse("$baseUrl/customers");
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization":
              "Bearer ${partnerTokenFromAdmin ?? 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A'}"
        },
        body: jsonEncode(customerInfo.toJson()));
    if (response.statusCode == 200) {
      print('Customer created successfully');
    } else {
      print('Failed to create customer');
      throw Exception('Failed to create customer');
    }
  }
}
