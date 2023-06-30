//
//  SourceDetail.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';

part 'source_detail.g.dart';

@JsonSerializable()
class SourceDetail {
  List<String> imageUrls;
  bool isActive;
  int likesCount;
  String modifiedDate;
  String publishedDate;
  int rating;
  int ratingCount;
  int reviewCount;
  String source;
  String url;
  String videoUrl;


  factory SourceDetail.fromJson(Map<String, dynamic> json) => _$SourceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SourceDetailToJson(this);

  SourceDetail(
      {
      required this.imageUrls,
      required this.isActive,
      required this.likesCount,
      required this.modifiedDate,
      required this.publishedDate,
      required this.rating,
      required this.ratingCount,
      required this.reviewCount,
      required this.source,
      required this.url,
      required this.videoUrl
      });

  static SourceDetail empty() => SourceDetail(
      imageUrls: [], isActive: false, likesCount: 0, modifiedDate: '', publishedDate: '', rating: 0, ratingCount: 0, reviewCount: 0, source: '', url: '', videoUrl: '');
}