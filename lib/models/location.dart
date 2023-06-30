//
//  Location.dart
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2020

import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  String city;
  String country;
  String gps;

  @JsonKey(name: 'ip_addr')
  String ipAddr;
  String state;
  String zip;

  Location({
    required this.city,
    required this.country,
    required this.gps,
    required this.ipAddr,
    required this.state,
    required this.zip,
  });

  static Location empty() => Location(city: '', country: '', gps: '', ipAddr: '', state: '', zip: '');

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
