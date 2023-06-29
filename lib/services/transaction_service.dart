import 'dart:convert';

import 'package:partner_mobile/models/transaction_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  static String baseUrl = "https://my-happygear.azurewebsites.net/happygear/partner/api";

  static Future<List<TransactionHistoryModel>> getAllTransactionHistory(String customerId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var response = await http.get(
        Uri.parse('$baseUrl/requests?customerId=$customerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization":
            "Bearer ${partnerTokenFromAdmin ??
              'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwYXJ0bmVyQGdtYWlsLmNvbSIsImlhdCI6MTY4NzE0MDkyOCwiZXhwIjoxNzA0NDIwOTI4fQ.y5QArBBgjW0BGJH2B9hnFrdMQ92kQmAtSRX-vMKimhahoGBiu2YWGY9nGEmLT8K7GpUbTpT3jaEPCtL-NaRs7A'}"
        }
    );
    List<TransactionHistoryModel> transactionHistory = [];
    if (response.statusCode == 200) {
      var transactionHistoryJson = json.decode(utf8.decode(response.bodyBytes));
      for (var transactionHistoryJson in transactionHistoryJson) {
        transactionHistory.add(TransactionHistoryModel.fromJson(transactionHistoryJson));
      }
    }
    else {
      throw Exception('Failed to load transaction history');
    }
    return transactionHistory;
  }
}