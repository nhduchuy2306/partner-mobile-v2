import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/momo_response.dart';

class MoMoService {
  static const String baseUrl =
      "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<String?> getPayUrl(int amount) async {
    var response = await http
        .get(Uri.parse('$baseUrl/payment/create-order?amount=$amount'));

    MoMoResponse momoResponse = MoMoResponse();

    if (response.statusCode == 200) {
      var momoResponseJson = json.decode(utf8.decode(response.bodyBytes));
      momoResponse = MoMoResponse.fromJson(momoResponseJson);
      return momoResponse.payUrl;
    }
    return "";
  }
}
