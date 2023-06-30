// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) =>
    NutritionInfo(
      json['caloriesFromFat'] as int,
      json['cholesterol'] as int,
      json['cholesterolPct'] as int,
      json['dietaryFiber'] as int,
      json['dietaryFiberPct'] as int,
      (json['dietLabels'] as List<dynamic>).map((e) => e as String).toList(),
      (json['healthLabels'] as List<dynamic>).map((e) => e as String).toList(),
      json['monoFat'] as int,
      json['polyFat'] as int,
      json['potassium'] as int,
      json['potassiumPct'] as int,
      json['protein'] as int,
      json['proteinPct'] as int,
      json['singularYieldUnit'] as String,
      json['sodium'] as int,
      json['sodiumPct'] as int,
      json['sugar'] as int,
      json['totalCalories'] as int,
      json['totalCarbs'] as int,
      json['totalCarbsPct'] as int,
      json['totalFat'] as int,
      json['totalFatPct'] as int,
      json['transFat'] as int,
    );

Map<String, dynamic> _$NutritionInfoToJson(NutritionInfo instance) =>
    <String, dynamic>{
      'caloriesFromFat': instance.caloriesFromFat,
      'cholesterol': instance.cholesterol,
      'cholesterolPct': instance.cholesterolPct,
      'dietaryFiber': instance.dietaryFiber,
      'dietaryFiberPct': instance.dietaryFiberPct,
      'dietLabels': instance.dietLabels,
      'healthLabels': instance.healthLabels,
      'monoFat': instance.monoFat,
      'polyFat': instance.polyFat,
      'potassium': instance.potassium,
      'potassiumPct': instance.potassiumPct,
      'protein': instance.protein,
      'proteinPct': instance.proteinPct,
      'singularYieldUnit': instance.singularYieldUnit,
      'sodium': instance.sodium,
      'sodiumPct': instance.sodiumPct,
      'sugar': instance.sugar,
      'totalCalories': instance.totalCalories,
      'totalCarbs': instance.totalCarbs,
      'totalCarbsPct': instance.totalCarbsPct,
      'totalFat': instance.totalFat,
      'totalFatPct': instance.totalFatPct,
      'transFat': instance.transFat,
    };
