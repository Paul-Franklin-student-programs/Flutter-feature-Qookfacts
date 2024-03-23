import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String dietaryRestrictions = 'dietary_restrictions';
  static const String virtualPantry = 'virtual_pantry';

  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<List<String>>(HiveBoxes.dietaryRestrictions);
    await Hive.openBox<List<String>>(HiveBoxes.virtualPantry);
  }
}
