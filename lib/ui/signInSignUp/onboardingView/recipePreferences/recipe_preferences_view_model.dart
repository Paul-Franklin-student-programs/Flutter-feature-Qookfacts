import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/services/services.dart';
import 'package:stacked/stacked.dart';

class RecipePreferencesViewModel extends BaseViewModel{
  String title = 'What are your recipe preferences?';
  String background = 'assets/images/v2/app_logo.png';
  // String nextRoute = Routes.navigationView;
  String nextRoute = '';

  List<String> recipes = [
    'Easy',
    'Kid-Friendly',
    'Sheet Pan',
    'Grilled',
    'Instant Pot',
    'Quick',
    'Chicken',
    'Steak',
    'Pasta',
    'Fish'
  ];

  List<dynamic> get recipesSelected{
    return hiveService.recipesBox.keys.toList();
  }

  void updateRecipes(String option) {
    if (!hiveService.recipesBox.containsKey(option)) {
      hiveService.recipesBox.put(option, 'true');
    } else {
      hiveService.recipesBox.delete(option);
    }
    notifyListeners();
  }
}