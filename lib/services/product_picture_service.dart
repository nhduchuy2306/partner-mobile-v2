import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_mobile/models/product_picture.dart';

class ProductPictureService {
  static String baseUrl =
      "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<List<ProductPicture>> getAllPictureForProductById(
      int productId) async {
    var response =
        await http.get(Uri.parse('$baseUrl/products/$productId/pictures'));
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
