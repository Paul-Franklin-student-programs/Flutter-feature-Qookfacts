
//
//  Comment.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String createdDate;
  String modifiedDate;
  String name;
  String rating;
  String text;
  String userId;

  Comment(this.createdDate, this.modifiedDate, this.name, this.rating,
      this.text, this.userId);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  static Comment empty() => Comment('', '', '', '', '', '');
}