// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_root.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientRoot _$IngredientRootFromJson(Map<String, dynamic> json) =>
    IngredientRoot(
      json['firstPageToken'] as String,
      json['itemCount'] as int,
      (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['lastPageToken'] as String,
      json['nextPageToken'] as String,
      json['prevPageToken'] as String,
      json['totalItemCount'] as int,
      json['totalPageCount'] as int,
    );

Map<String, dynamic> _$IngredientRootToJson(IngredientRoot instance) =>
    <String, dynamic>{
      'firstPageToken': instance.firstPageToken,
      'itemCount': instance.itemCount,
      'items': instance.items,
      'lastPageToken': instance.lastPageToken,
      'nextPageToken': instance.nextPageToken,
      'prevPageToken': instance.prevPageToken,
      'totalItemCount': instance.totalItemCount,
      'totalPageCount': instance.totalPageCount,
    };
