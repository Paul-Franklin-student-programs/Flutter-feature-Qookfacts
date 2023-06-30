// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['icon'] as String,
      json['imageUrl'] as String,
      json['name'] as String,
      NutritionInfo.fromJson(json['nutritionInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'icon': instance.icon,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'nutritionInfo': instance.nutritionInfo,
    };
