import 'package:flutter/material.dart';

class DietaryRestrictionsProvider extends ChangeNotifier {
  List<String> _dietaryRestrictions = [];

  List<String> get dietaryRestrictions => _dietaryRestrictions;

  void addDietaryRestriction(String restriction) {
    _dietaryRestrictions.add(restriction);
    notifyListeners();
  }

  void removeDietaryRestriction(String restriction) {
    _dietaryRestrictions.remove(restriction);
    notifyListeners();
  }
}
