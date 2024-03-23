import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';

@singleton
class HiveService {
  late Box userBox;
  late Box dietRestrictionsBox; // Updated variable name

  Future<void> setupHive(String userId) async {
    await _openBoxes(userId);
  }

  Future<void> _openBoxes(String userId) async {
    await Hive.openBox('user_$userId');
    userBox = Hive.box('user_$userId');

    dietRestrictionsBox = await Hive.openBox('diet_restrictions_$userId'); // Updated box name and variable assignment
  }

  ValueListenable<Box<dynamic>> get dietRestrictionsListenable { // Updated method name
    return dietRestrictionsBox.listenable(); // Updated variable name
  }

  Future<void> addUserDietaryRestriction(String userId, String restriction) async {
    await _openBoxes(userId);
    await dietRestrictionsBox.put(restriction, true); // Updated variable name
  }

  Future<void> removeUserDietaryRestriction(String userId, String restriction) async {
    await _openBoxes(userId);
    await dietRestrictionsBox.delete(restriction); // Updated variable name
  }

  List<String> getUserDietaryRestrictions(String userId) {
    return dietRestrictionsBox.keys.cast<String>().toList(); // Updated variable name
  }
}
