// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      Author.fromJson(json['author'] as Map<String, dynamic>),
      (json['chefNotes'] as List<dynamic>).map((e) => e as String).toList(),
      Comment.fromJson(json['comments'] as Map<String, dynamic>),
      (json['cookMethod'] as List<dynamic>).map((e) => e as String).toList(),
      json['cookTime'] as int,
      json['createdBy'] as String,
      json['createdDate'] as String,
      (json['cuisines'] as List<dynamic>).map((e) => e as String).toList(),
      json['description'] as String,
      json['difficultyRating'] as int,
      (json['dishName'] as List<dynamic>).map((e) => e as String).toList(),
      (json['dishTypes'] as List<dynamic>).map((e) => e as String).toList(),
      json['id'] as String,
      (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['instructions'] as List<dynamic>)
          .map((e) => Instruction.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['isPrivate'] as bool,
      json['isSponsored'] as bool,
      json['likesCount'] as int,
      json['modifiedBy'] as String,
      json['modifiedDate'] as String,
      NutritionInfo.fromJson(json['nutritionInfo'] as Map<String, dynamic>),
      json['prepTime'] as int,
      json['rating'] as int,
      json['ratingCount'] as int,
      json['reviewCount'] as int,
      json['servingsMax'] as int,
      json['servinsMin'] as int,
      SourceDetail.fromJson(json['sourceDetail'] as Map<String, dynamic>),
      json['title'] as String,
      json['totalTime'] as int,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'author': instance.author,
      'chefNotes': instance.chefNotes,
      'comments': instance.comments,
      'cookMethod': instance.cookMethod,
      'cookTime': instance.cookTime,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'cuisines': instance.cuisines,
      'description': instance.description,
      'difficultyRating': instance.difficultyRating,
      'dishName': instance.dishName,
      'dishTypes': instance.dishTypes,
      'id': instance.id,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'isPrivate': instance.isPrivate,
      'isSponsored': instance.isSponsored,
      'likesCount': instance.likesCount,
      'modifiedBy': instance.modifiedBy,
      'modifiedDate': instance.modifiedDate,
      'nutritionInfo': instance.nutritionInfo,
      'prepTime': instance.prepTime,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'reviewCount': instance.reviewCount,
      'servingsMax': instance.servingsMax,
      'servinsMin': instance.servinsMin,
      'sourceDetail': instance.sourceDetail,
      'title': instance.title,
      'totalTime': instance.totalTime,
    };
