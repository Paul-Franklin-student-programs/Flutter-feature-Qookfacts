// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['extUserId'] as String,
      json['fullName'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'extUserId': instance.extUserId,
      'fullName': instance.fullName,
      'userId': instance.userId,
    };
