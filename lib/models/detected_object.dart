import 'package:json_annotation/json_annotation.dart';
import 'package:qookit/models/detected_location.dart';

part 'detected_object.g.dart';

@JsonSerializable()
class DetectedObject {
  double confidence;
  int detectedClass;
  String id;
  DetectedLocation? location;
  String title;

  DetectedObject(
      {
      required this.confidence,
      required this.detectedClass,
      required this.id,
      required this.location,
      required this.title
      });

  factory DetectedObject.fromJson(Map<String, dynamic> json) =>
      _$DetectedObjectFromJson(json);

  Map<String, dynamic> toJson() => _$DetectedObjectToJson(this);
}
