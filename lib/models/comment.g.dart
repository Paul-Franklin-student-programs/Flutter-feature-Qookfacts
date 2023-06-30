// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['createdDate'] as String,
      json['modifiedDate'] as String,
      json['name'] as String,
      json['rating'] as String,
      json['text'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'createdDate': instance.createdDate,
      'modifiedDate': instance.modifiedDate,
      'name': instance.name,
      'rating': instance.rating,
      'text': instance.text,
      'userId': instance.userId,
    };
