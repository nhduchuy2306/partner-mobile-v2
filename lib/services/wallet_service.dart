import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  static const baseUrl = "https://swd-back-end.azurewebsites.net/partner/api";

  static Future<List<WalletModel>> getAllWallet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var response = await http.get(
      Uri.parse('$baseUrl/wallet-types'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $partnerTokenFromAdmin'
      },
    );
    List<WalletModel> walletList = [];
    if (response.statusCode == 200) {
      var walletJson = json.decode(utf8.decode(response.bodyBytes));
      for (var wallet in walletJson) {
        walletList.add(WalletModel.fromJson(wallet));
      }
    } else {
      print('Wallet not found');
      return [];
    }
    return walletList;
  }

  static Future<void> createWallet(int memberShipId, int typeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerTokenFromAdmin = prefs.getString('partnerTokenFromAdmin');
    var response = await http.post(
      Uri.parse('$baseUrl/wallets?membershipId=$memberShipId&typeId=$typeId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $partnerTokenFromAdmin'
      },
    );
    if (response.statusCode == 201) {
      print('Create wallet success');
    } else {
      print('Create wallet failed');
    }
  }
}
