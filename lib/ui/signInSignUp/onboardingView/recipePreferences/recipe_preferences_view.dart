import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qookit/services/services.dart';
import 'package:qookit/ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view_model.dart';
import 'package:qookit/ui/signInSignUp/onboardingView/shared_onboarding_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_route/annotations.dart';

@RoutePage()
class RecipePreferencesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecipePreferencesViewModel>.reactive(
        viewModelBuilder: () => RecipePreferencesViewModel(),
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  BackgroundImage(model.background),
                  OnboardingTitle(model.title),
                  Recipes(model, context),
                  OnboardingButtons(context, true, true, model.nextRoute)
                ],
              ),
            ),
          ));
        });
  }

  Widget Recipes(RecipePreferencesViewModel model, BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hiveService.recipesListenable,
      builder: (context, box, child) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 4,
                mainAxisSpacing: 10,
                children: [
                  for (String recipe in model.recipes)
                    RecipeOption(recipe, context, model, box as Box<dynamic>)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  Widget RecipeOption(String label, BuildContext context,
      RecipePreferencesViewModel model, Box box) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: box.containsKey(label) ? Colors.black : Colors.white,
            border: Border.all(
                color: box.containsKey(label) ? Colors.black : Colors.grey)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: box.containsKey(label) ? Colors.white : Colors.black,
              fontSize: 15,
              height: 1.1,
              fontWeight: FontWeight.w600,
              fontFamily: 'opensans',
            ),
          ),
        ),
      ),
      onTap: () {
        model.updateRecipes(label);
      },
    );
  }
}
