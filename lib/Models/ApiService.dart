import 'package:http/http.dart' as http;
import 'package:recipedia/Models/Recipe.dart';
import '../Constants/Api.dart' as api;
import 'dart:convert';

class ApiProvider {
  final String baseUrl = api.baseURL;

  Future<List<Recipe>> getRecipes() async {
    final response = await http.get(baseUrl + '/getAll');
    if (response.statusCode == 200) {
      List<Recipe> temp = [];
      temp.add(Recipe.fromJson(json.decode(response.body)));
      return temp;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }
}
