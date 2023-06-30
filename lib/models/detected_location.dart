import 'package:json_annotation/json_annotation.dart';

part 'detected_location.g.dart';

@JsonSerializable()
class DetectedLocation {
  double bottom;
  double left;
  double right;
  double top;

  DetectedLocation({required this.bottom,required this.left,required this.right,required this.top});

  factory DetectedLocation.fromJson(Map<String, dynamic> json) =>
      _$DetectedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$DetectedLocationToJson(this);
}