import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/product_description.dart';

class ProductDescriptionService {
  static String baseUrl =
      "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<ProductDescription> getDescriptionByProductId(int id) async {
    var response =
        await http.get(Uri.parse('$baseUrl/products/$id/description'));
    ProductDescription productDescription = ProductDescription();
    if (response.statusCode == 200) {
      var productDescriptionJson = json.decode(utf8.decode(response.bodyBytes));
      productDescription = ProductDescription.fromJson(productDescriptionJson);
    }
    return productDescription;
  }
}
