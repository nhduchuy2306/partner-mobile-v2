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
      int page,
      int limit,
      String? searchText,
      List<int>? brandIds,
      List<int>? categoryIds,
      double? fromPrice,
      double? toPrice) async {
    String? listBrand = "";
    String? listCategory = "";
    String url = "$baseUrl/products?page=$page&limit=$limit";

    if (brandIds != null && brandIds.isNotEmpty) {
      for (int i = 0; i < brandIds.length; i++) {
        if (i == brandIds.length - 1) {
          listBrand = "${listBrand}brandIds=${brandIds[i]}";
        } else {
          listBrand = "${listBrand}brandIds=${brandIds[i]}&";
        }
      }
    }

    if (categoryIds != null && categoryIds.isNotEmpty) {
      for (int i = 0; i < categoryIds.length; i++) {
        if (i == categoryIds.length - 1) {
          listCategory = "${listCategory}categoryIds=${categoryIds[i]}";
        } else {
          listCategory = "${listCategory}categoryIds=${categoryIds[i]}&";
        }
      }
    }

    if(searchText != null && searchText.isNotEmpty){
      url = "$url&search=$searchText";
    }
    if(listBrand != null && listBrand.isNotEmpty){
      url = "$url&$listBrand";
    }
    if(listCategory != null && listCategory.isNotEmpty){
      url = "$url&$listCategory";
    }
    if(fromPrice != null){
      url = "$url&fromPrice=$fromPrice";
    }
    if(toPrice != null){
      url = "$url&toPrice=$toPrice";
    }

    var response = await http.get(Uri.parse(url));
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
