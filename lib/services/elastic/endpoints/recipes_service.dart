import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:qookit/models/recipe.dart';
import 'package:qookit/models/recipe_list.dart';
import 'package:qookit/services/services.dart';

// Class to managa all recipe-related requests and search results
@singleton
class RecipesService {
  static const String endpoint = '/v1/recipes';

  List<Recipe> searchRecipes = [];
  List<Recipe> suggestedRecipes = [];
  List<Recipe> seasonalRecipes = [];
  List<Recipe> dietRecipes = [];

  Future<List<Recipe>> getRecipeFromSearch(
      RecipeParameters recipeParameters) async {
    searchRecipes = [];
    var uri =
        Uri.https(elasticService.domain, endpoint, recipeParameters.toMap());
    var token = await authService.token;
    print('token = ' + token);
    var recipeResponse = await http.get(
      uri,
      headers: {
        //HttpHeaders.authorizationHeader
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    RecipeList recipeList =
        RecipeList.fromJson(jsonDecode(recipeResponse.body));
    //assert(recipeList.recipes.first == recipeList.recipes);
    //print(recipeList.recipes);
    //Recipe testRecipe = recipeList.recipes.first;
    //Recipe testRecipe = Recipe.fromJSON(recipeList.recipes.first);
    //print('recipes type: '+  testRecipe.title);
    //print('recipes: '+  jsonDecode(recipeList.recipes.first.toString()));

    // Add the results to the searchResults list
    recipeList.recipes.forEach((recipe) {
      print('adding recipe');
      searchRecipes.add(recipe);
    });

    print(searchRecipes.toString());
    print('Response status: ${recipeResponse.statusCode}');
    print('Response body: ${recipeResponse.body}');
    print('Response recipe: ${recipeList.recipes.first}');

    return searchRecipes;
  }

  Future<List<Recipe>> getSuggestedRecipes(
      {required RecipeParameters recipeParameters}) async {
    RecipeParameters queryParameters;
    if (recipeParameters == null) {
      queryParameters = RecipeParameters(searchString: 'beef', cuisine: [], dishTypes: [], cookMethod: [], dietLabels: [],);
    } else {
      queryParameters = recipeParameters;
    }

    suggestedRecipes = [];
    var uri =
        Uri.https(elasticService.domain, endpoint, queryParameters.toMap());
    var token = await authService.token;
    print('----------------------------------------');
    var recipeResponse = await http.get(
      uri,
      headers: {
        //HttpHeaders.authorizationHeader
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    RecipeList recipeList =
        RecipeList.fromJson(jsonDecode(recipeResponse.body));

    // Add the results to the searchResults list
    recipeList.recipes.forEach((recipe) {
      print('adding recipe');
      suggestedRecipes.add(recipe);
    });

    print(suggestedRecipes.toString());
    print('Response status: ${recipeResponse.statusCode}');
    print('Response body: ${recipeResponse.body}');
    print('Response recipe: ${recipeList.recipes.first}');

    return suggestedRecipes;
  }
}

class RecipeParameters {
  String searchString = '';
  String dishName = '';
  List<String> cuisine= [];
  List<String> dishTypes= [];
  List<String> cookMethod= [];
  int maxTotalTime = 0;
  int minRating = 0;
  int maxTotalCalories = 0;
  List<String> dietLabels;
  int pageSize = 0;
  String pageToken = '';
  String include = '';

  RecipeParameters({
    this.searchString = '',
    this.dishName = '',
    required this.cuisine,
    required this.dishTypes,
    required this.cookMethod,
    this.maxTotalTime = 0,
    this.minRating  = 0,
    this.maxTotalCalories  = 0,
    required this.dietLabels,
    this.pageSize = 0,
    this.pageToken = '',
    this.include = '',
  });

  static RecipeParameters empty() => RecipeParameters(
      cuisine: [],
      dishTypes: [],
      cookMethod: [],
      dietLabels: []
  );

  Map<String, String> toMap() {
    return {
      if (searchString != null) 'searchString': searchString.toString(),
      if (dishName != null) 'dishName': dishName.toString(),
      if (cuisine != null) 'cuisine': cuisine.toString(),
      if (dishTypes != null) 'dishTypes': dishTypes.toString(),
      if (cookMethod != null) 'cookMethod': cookMethod.toString(),
      if (maxTotalTime != null) 'maxTotalTime': maxTotalTime.toString(),
      if (minRating != null) 'minRating': minRating.toString(),
      if (maxTotalCalories != null)
        'maxTotalCalories': maxTotalCalories.toString(),
      if (dietLabels != null) 'dietLabels': dietLabels.toString(),
      if (pageSize != null) 'pageSize': pageSize.toString(),
      if (pageToken != null) 'pageToken': pageToken.toString(),
      if (include != null) 'include': include.toString()
    };
  }
}
