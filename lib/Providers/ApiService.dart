import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
    temp =  RecipeModel.fromJson(json.decode(response.body)).data;
      // temp.add(Recipe.fromJson(json.decode(response.body)));
      return temp;
     
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> createRecipe(File file, Map data) async {
    var formdata = FormData.fromMap(data);

  // TO DO , ADD FILE UPLOAD 

    var response = await Dio().post(baseUrl + '/create', data: formdata);
    print(response);
    return null;
  }

  Future<void> logIn(String id, String username, String profileUrl) async {
    var response = await Dio().post(baseUrl + '/login',
        data: {'displayName': username, 'id': id, 'profileImg': profileUrl});
    print(response);
    return null;
  }

  Future<void> like(String recipeID) async {
    var response = await Dio().post(baseUrl + '/like', data: {
      'id': recipeID,
    });
    print(response);
    return null;
  }

  Future<void> rate(String recipeID, int rating) async {
    var response = await Dio()
        .post(baseUrl + '/rate', data: {'id': recipeID, 'rating': rating});
    print(response);
    return null;
  }

    Future<List<Recipe>> searchRecipe() async {
    final response = await http.get(baseUrl + '/search');
    // IMPLEMENT SEARCH 
  }
}
