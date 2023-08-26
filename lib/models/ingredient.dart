//
//  Ingredient.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  String ingredientId;
  String name;
  String prepNote;
  int quantity;
  String text;
  String unit;

  Ingredient(
      {
      required this.ingredientId,
      required this.name,
      required this.prepNote,
      required this.quantity,
      required this.text,
      required this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
