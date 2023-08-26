import 'package:qookit/models/recipe.dart';
import 'package:qookit/services/elastic/endpoints/recipes_service.dart';
import 'package:qookit/services/services.dart';
import 'package:stacked/stacked.dart';

// Future keys **************************************************************************
const String _SuggestedFuture = 'delayedSuggested';
const String _SeasonalFuture = 'delayedSeasonal';
const String _DietFuture = 'delayedDiet';
const String _FoodFuture = 'foodString';

class RecipesViewModel extends MultipleFutureViewModel  {
  // Busy signals **************************************************************************
  bool get fetchingSuggested => busy(_SuggestedFuture);
  bool get fetchingSeasonal => busy(_SeasonalFuture);
  bool get fetchingDiet => busy(_DietFuture);
  bool get fetchingFood => busy(_FoodFuture);

  // Future Getters **************************************************************************
  List<Recipe> get suggestedRecipes => dataMap?[_SuggestedFuture];
  List<Recipe> get seasonalRecipes => dataMap?[_SeasonalFuture];
  List<Recipe> get dietRecipes => dataMap?[_DietFuture];
  List<Recipe> get foodRecipes => dataMap?[_FoodFuture];

  bool showSearchBar = false;

  List<Recipe> searchRecipesList = [];

  void toggleSearchBar() {
    showSearchBar = !showSearchBar;
    notifyListeners();
  }

  @override
  Map<String, Future Function()> get futuresMap => {
    _SuggestedFuture : () => recipeService.getSuggestedRecipes(recipeParameters: RecipeParameters.empty()),
    _SeasonalFuture : () => recipeService.getSuggestedRecipes(recipeParameters: RecipeParameters.empty()),
    _DietFuture : () => recipeService.getSuggestedRecipes(recipeParameters: RecipeParameters.empty()),
    _FoodFuture : () => recipeService.getSuggestedRecipes(recipeParameters: RecipeParameters.empty()),
  };
}
