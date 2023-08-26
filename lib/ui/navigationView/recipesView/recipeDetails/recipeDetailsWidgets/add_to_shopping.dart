import 'package:flutter/material.dart';
import 'package:qookit/ui/navigationView/recipesView/recipeDetails/recipe_details_view_model.dart';
import 'package:stacked/stacked.dart';

class AddToShoppingList extends ViewModelWidget<RecipeDetailsViewModel> {
  @override
  Widget build(BuildContext context, RecipeDetailsViewModel model) {
    return Center(
      child: IconButton(
        icon: Text('ADD TO SHOPPING LIST'),
        color: Colors.amber,
        onPressed: (){

        },
      ),
    );
  }

}
