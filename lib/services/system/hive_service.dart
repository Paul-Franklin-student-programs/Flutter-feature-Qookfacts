import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:qookit/services/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

@singleton
class  HiveService {
  late Box userBox;
  late Box dietsBox;
  late Box recipesBox;
  late Box recommendationsBox;
  late Box pantryBox;
  late Box freezerBox;
  late Box fridgeBox;
  late Box myRecipesBox;
  late Box favoriteRecipesBox;

  Future<void> setupHive() async {
    await Hive.openBox('user_${authService.uid}');
    userBox = Hive.box('user_${authService.uid}');

    // Open boxes for user preferences
    await Hive.openBox('diets_${authService.uid}');
    dietsBox = Hive.box('diets_${authService.uid}');
    await Hive.openBox('recipes_${authService.uid}');
    recipesBox = Hive.box('recipes_${authService.uid}');
    await Hive.openBox('recommendations_${authService.uid}');
    recommendationsBox = Hive.box('recommendations_${authService.uid}');

    // Open boxes for pantries
    await Hive.openBox('pantry_${authService.uid}');
    pantryBox = Hive.box('pantry_${authService.uid}');
    await Hive.openBox('freezer_${authService.uid}');
    freezerBox = Hive.box('freezer_${authService.uid}');
    await Hive.openBox('fridge_${authService.uid}');
    fridgeBox = Hive.box('fridge_${authService.uid}');

    // Open boxes for recipes
    await Hive.openBox('my_recipes_${authService.uid}');
    myRecipesBox = Hive.box('my_recipes_${authService.uid}');
    await Hive.openBox('favorite_recipes_${authService.uid}');
    favoriteRecipesBox = Hive.box('favorite_recipes_${authService.uid}');
  }


  // ValueListenables for building widgets dynamically
  ValueListenable<Box<dynamic>> get dietsListenable {
    return dietsBox.listenable();
  }

  ValueListenable<Box<dynamic>> get recipesListenable {
    return recipesBox.listenable();
  }

  ValueListenable<Box<dynamic>> get recommendationsListenable {
    return recommendationsBox.listenable();
  }

  ValueListenable<Box<dynamic>> get pantryListenable {
    return pantryBox.listenable();
  }

  ValueListenable<Box<dynamic>> get fridgeListenable {
    return fridgeBox.listenable();
  }

  ValueListenable<Box<dynamic>> get freezerListenable {
    return freezerBox.listenable();
  }

  ValueListenable<Box<dynamic>> get myRecipesListenable {
    return myRecipesBox.listenable();
  }

  ValueListenable<Box<dynamic>> get favoriteRecipesListenable {
    return favoriteRecipesBox.listenable();
  }
}