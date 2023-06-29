import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/raise_recharge_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaiseRechargeService {
  // static String baseUrl =
  //     "https://swd-back-end.azurewebsites.net/partner/api/requests";
  static String baseUrl = "https://my-happygear.azurewebsites.net/happygear/partner/api";

  static Future<void> raiseRechargeRequest(RaiseWallet raiseWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin') ??
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A';
    var url = Uri.parse("$baseUrl/requests/addition");
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $partnerTokenFromAdmin'
        },
        body: jsonEncode(raiseWallet.toJson()));
    if (response.statusCode == 200) {
      print('Recharge request raised successfully');
    } else {
      print('Failed to raise recharge request');
      throw Exception('Failed to raise recharge request');
    }
  }

  static Future<void> reduceRequest(ReduceWallet reduceWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin') ??
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A';
    var url = Uri.parse("$baseUrl/requests/subtraction");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $partnerTokenFromAdmin"
        },
        body: jsonEncode(reduceWallet.toJson()));
    if (response.statusCode == 200) {
      print('Recharge request raised successfully');
    } else {
      print('Failed to raise recharge request');
      throw Exception('Failed to raise recharge request');
    }
  }
}
