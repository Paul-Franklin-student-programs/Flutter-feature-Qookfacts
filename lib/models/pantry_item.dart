//
//  PantryItem.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qookit/models/expiry_group.dart';

part 'pantry_item.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class PantryItem {
  @HiveField(0)
  String category;
  List<ExpiryGroup> expiryGroups;
  String ingredientId;
  @HiveField(1)
  bool isFrozen;
  @HiveField(2)
  bool isRefrigerated;
  @HiveField(3)
  String name;
  @HiveField(4)
  String notes;
  @HiveField(5)
  String photoUrl;

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);

  Map<String, dynamic> toJson() => _$PantryItemToJson(this);

  PantryItem(
      {required this.category,
      required this.expiryGroups,
      required this.ingredientId,
      required this.isFrozen,
      required this.isRefrigerated,
      required this.name,
      required this.notes,
      required this.photoUrl});
  static PantryItem empty() => PantryItem(
      category: '',
      expiryGroups: [],
      ingredientId: '',
      isFrozen: false,
      isRefrigerated: false,
      name: '',
      notes: '',
      photoUrl: '');
}
