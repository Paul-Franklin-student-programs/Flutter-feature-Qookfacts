//
//  Item.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';
import 'package:qookit/models/ingredient.dart';
import 'package:qookit/models/author.dart';
import 'package:qookit/models/comment.dart';
import 'package:qookit/models/instruction.dart';
import 'package:qookit/models/nutrition_info.dart';
import 'package:qookit/models/source_detail.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  Author author = Author.empty();
  List<String> chefNotes;
  Comment comments;
  List<String> cookMethod;
  int cookTime;
  String createdBy;
  String createdDate;
  List<String> cuisines;
  String description;
  int difficultyRating;
  List<String> dishName;
  List<String> dishTypes;
  String id;
  List<Ingredient> ingredients;
  List<Instruction> instructions;
  bool isPrivate;
  bool isSponsored;
  int likesCount;
  String modifiedBy;
  String modifiedDate;
  NutritionInfo nutritionInfo;
  int prepTime;
  int rating;
  int ratingCount;
  int reviewCount;
  int servingsMax;
  int servinsMin;
  SourceDetail sourceDetail;
  String title;
  int totalTime;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  static Recipe empty() => Recipe(
      Author.empty(),
      [],
      Comment.empty(),
      [],
      0,
      '',
      '',
      [],
      '',
      0,
      [],
      [],
      '',
      [],
      [],
      false,
      false,
      0,
      '',
      '',
      NutritionInfo.empty(),
      0,
      0,
      0,
      0,
      0,
      0,
      SourceDetail.empty(),
      '',
      0
  );

  Recipe(
      this.author,
      this.chefNotes,
      this.comments,
      this.cookMethod,
      this.cookTime,
      this.createdBy,
      this.createdDate,
      this.cuisines,
      this.description,
      this.difficultyRating,
      this.dishName,
      this.dishTypes,
      this.id,
      this.ingredients,
      this.instructions,
      this.isPrivate,
      this.isSponsored,
      this.likesCount,
      this.modifiedBy,
      this.modifiedDate,
      this.nutritionInfo,
      this.prepTime,
      this.rating,
      this.ratingCount,
      this.reviewCount,
      this.servingsMax,
      this.servinsMin,
      this.sourceDetail,
      this.title,
      this.totalTime);
}
