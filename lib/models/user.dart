//
//  UserRoot.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';
import 'package:qookit/models/personal.dart';
import 'package:qookit/models/preference.dart';
import 'package:qookit/models/recipe.dart';

part 'user.g.dart';

@JsonSerializable()
class UserRoot {
  String backgroundUrl;
  String displayName;
  String id;
  List<String> pantryItems;
  Personal personal;
  String photoUrl;
  Preference preferences;
  List<Recipe> recipes;
  String userName;

  UserRoot({
    required this.backgroundUrl,
    required this.displayName,
    required this.id,
    required this.pantryItems,
    required this.personal,
    required this.photoUrl,
    required this.preferences,
    required this.recipes,
    required this.userName,
  });

  static UserRoot empty() => UserRoot(
      backgroundUrl: '',
      displayName: '',
      id: '',
      pantryItems: [],
      personal: Personal.empty(),
      photoUrl: '',
      preferences: Preference.empty(),
      recipes: [],
      userName: '',
  );

  factory UserRoot.fromJson(Map<String, dynamic> json) => _$UserRootFromJson(json);

  Map<String, dynamic> toJson() => _$UserRootToJson(this);
}
