import 'dart:convert';

import 'package:partner_mobile/models/product_picture.dart';
import 'package:http/http.dart' as http;

class ProductPictureService {
  static String baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";


  static Future<List<ProductPicture>> getAllPictureForProductById(int productId) async {
    var response = await http.get(Uri.parse('$baseUrl/pictures/product/$productId'));
    List<ProductPicture> productPictures = [];
    if (response.statusCode == 200) {
      var productPicturesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var productPictureJson in productPicturesJson) {
        productPictures.add(ProductPicture.fromJson(productPictureJson));
      }
    }
    return productPictures;
  }

}