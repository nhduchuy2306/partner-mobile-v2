import 'dart:convert';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";

  static Future<List<Category>> getCategories() async {
    var response = await http.get(Uri.parse('$baseUrl/categories'));
    List<Category> categories = [];
    if (response.statusCode == 200) {
      var categoriesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var categoryJson in categoriesJson) {
        categories.add(Category.fromJson(categoryJson));
      }
    }
    return categories;
  }

  static Future<Category> getCategory(int id) async {
    var response = await http.get(Uri.parse('$baseUrl/categories/$id'));
    Category category = Category();
    if (response.statusCode == 200) {
      var categoryJson = json.decode(utf8.decode(response.bodyBytes));
      category = Category.fromJson(categoryJson);
    }
    return category;
  }
}