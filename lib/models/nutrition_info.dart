//
//  NutritionInfo.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';

part 'nutrition_info.g.dart';

@JsonSerializable()
class NutritionInfo {
  int caloriesFromFat;
  int cholesterol;
  int cholesterolPct;
  int dietaryFiber;
  int dietaryFiberPct;
  List<String> dietLabels;
  List<String> healthLabels;
  int monoFat;
  int polyFat;
  int potassium;
  int potassiumPct;
  int protein;
  int proteinPct;
  String singularYieldUnit;
  int sodium;
  int sodiumPct;
  int sugar;
  int totalCalories;
  int totalCarbs;
  int totalCarbsPct;
  int totalFat;
  int totalFatPct;
  int transFat;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) => _$NutritionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionInfoToJson(this);

  NutritionInfo(
      this.caloriesFromFat,
      this.cholesterol,
      this.cholesterolPct,
      this.dietaryFiber,
      this.dietaryFiberPct,
      this.dietLabels,
      this.healthLabels,
      this.monoFat,
      this.polyFat,
      this.potassium,
      this.potassiumPct,
      this.protein,
      this.proteinPct,
      this.singularYieldUnit,
      this.sodium,
      this.sodiumPct,
      this.sugar,
      this.totalCalories,
      this.totalCarbs,
      this.totalCarbsPct,
      this.totalFat,
      this.totalFatPct,
      this.transFat);

  static NutritionInfo empty() => NutritionInfo(0,0,0,0,0,[],[],0,00,0,0,00,0,'',0,0,0,0,0,0,0,0,0,);
}