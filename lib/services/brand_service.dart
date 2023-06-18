import 'dart:convert';

import 'package:partner_mobile/models/brand.dart';
import 'package:http/http.dart' as http;

class BrandService {
  static const String baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<List<Brand>> getBrands() async {
    var response = await http.get(Uri.parse('$baseUrl/brands'));
    List<Brand> categories = [];
    if (response.statusCode == 200) {
      var categoriesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var categoryJson in categoriesJson) {
        categories.add(Brand.fromJson(categoryJson));
      }
    }
    return categories;
  }
}