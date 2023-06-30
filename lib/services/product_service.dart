import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/product.dart';

class ProductService {
  static const baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<List<Product>> getLatestProducts() async {
    var response = await http.get(Uri.parse("$baseUrl/products/latest"));
    List<Product> products = [];
    if (response.statusCode == 200) {
      var productsJson = json.decode(utf8.decode(response.bodyBytes));
      for (var productJson in productsJson) {
        products.add(Product.fromJson(productJson));
      }
    }
    return products;
  }

  static Future<Product> getProductById(int id) async {
    var response = await http.get(Uri.parse('$baseUrl/products/$id'));
    Product product = Product();
    if (response.statusCode == 200) {
      var productJson = json.decode(utf8.decode(response.bodyBytes));
      product = Product.fromJson(productJson);
    }
    return product;
  }

  static Future<List<Product>> getBestSellingProducts() async {
    var response = await http.get(Uri.parse("$baseUrl/products/best-selling"));
    List<Product> products = [];
    if (response.statusCode == 200) {
      var productsJson = json.decode(utf8.decode(response.bodyBytes));
      for (var productJson in productsJson) {
        products.add(Product.fromJson(productJson));
      }
    }
    return products;
  }

  static Future<List<Product>> getAllProductPagination(
      int page, int size) async {
    var response =
        await http.get(Uri.parse("$baseUrl/products?page=$page&size=$size"));
    List<Product> products = [];
    if (response.statusCode == 200) {
      var productsJson = json.decode(utf8.decode(response.bodyBytes));
      for (var productJson in productsJson["data"]) {
        products.add(Product.fromJson(productJson));
      }
    }
    return products;
  }
}
