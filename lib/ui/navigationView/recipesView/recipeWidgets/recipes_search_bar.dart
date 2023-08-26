import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/app/strings.dart';
import 'package:stacked/stacked.dart';

class RecipesSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (searchTerm) {
        context.router.push(PageRouteInfo(
          'PantryView.dart',
          path: '../../ui/navigationView/pantryView/pantry_view.dart',
          args: {
            searchTerm: searchTerm,
            key: Key('2345'),
          },
        ));
        // ExtendedNavigator.named('nestedNav')?.push(
        //     NavigationViewRoutes.recipeSearchView,
        //     arguments: RecipeSearchViewArguments(searchTerm: searchTerm, key: Key('2345')));
      },
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: Strings.recipeSearch,
        hintStyle: TextStyle(fontFamily: 'opensans', color: Colors.black87),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black,
          size: 28,
        ),
        suffixIcon: IconButton(
          icon: FaIcon(FontAwesomeIcons.slidersH),
          onPressed: () {
            context.router.push(PageRouteInfo(
              'PantryView.dart',
              path: '../../ui/navigationView/pantryView/pantry_view.dart',
            ));
            // ExtendedNavigator.named('nestedNav')
            //     ?.push(NavigationViewRoutes.recipeSearchView);
          },
        ),
        contentPadding: EdgeInsets.all(0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
    );
  }
}
