import 'dart:convert';

import 'package:partner_mobile/models/raise_recharge_wallet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class RaiseRechargeService {
  static String baseUrl = "https://swd-back-end.azurewebsites.net/partner/api/requests";

  Future<void> raiseRechargeRequest(RaiseWallet raiseWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var url = Uri.parse("$baseUrl/addition");
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization":
      "Bearer ${partnerTokenFromAdmin ??
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A'}"
    }, body: jsonEncode(raiseWallet.toJson()));
    if (response.statusCode == 200) {
      print('Recharge request raised successfully');
    } else {
      print('Failed to raise recharge request');
      throw Exception('Failed to raise recharge request');
    }
  }

  Future<void> reduceRequest(ReduceWallet reduceWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var url = Uri.parse("$baseUrl/reduce");
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization":
      "Bearer ${partnerTokenFromAdmin ??
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A'}"
    }, body: jsonEncode(reduceWallet.toJson()));
    if (response.statusCode == 200) {
      print('Recharge request raised successfully');
    } else {
      print('Failed to raise recharge request');
      throw Exception('Failed to raise recharge request');
    }
  }
}