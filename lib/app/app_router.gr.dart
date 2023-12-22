// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:qookit/models/recipe.dart' as _i19;
import 'package:qookit/tflite_test/ui/old_home_view.dart' as _i16;
import 'package:qookit/ui/navigationView/navigation_view.dart' as _i8;
import 'package:qookit/ui/navigationView/pantryView/pantry_view.dart' as _i6;
import 'package:qookit/ui/navigationView/pantryView/pantryCatalog/pantry_catalog_view.dart'
    as _i7;
import 'package:qookit/ui/navigationView/profileView/profile_view.dart' as _i1;
import 'package:qookit/ui/navigationView/recipesView/myRecipes/my_recipes.dart'
    as _i3;
import 'package:qookit/ui/navigationView/recipesView/recipeDetails/recipe_details_view.dart'
    as _i2;
import 'package:qookit/ui/navigationView/recipesView/recipeSearch/recipe_search_view.dart'
    as _i4;
import 'package:qookit/ui/navigationView/shoppingView/shopping_view.dart'
    as _i5;
import 'package:qookit/ui/signInSignUp/forgotPasswordView/forgot_password_view.dart'
    as _i9;
import 'package:qookit/ui/signInSignUp/loginView/login_view.dart' as _i14;
import 'package:qookit/ui/signInSignUp/onboardingView/dietPreferences/diet_preferences_view.dart'
    as _i10;
import 'package:qookit/ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view.dart'
    as _i12;
import 'package:qookit/ui/signInSignUp/onboardingView/recommendationPreferences/recommendation_preferences_view.dart'
    as _i11;
import 'package:qookit/ui/signInSignUp/registerView/register_view.dart' as _i13;
import 'package:qookit/ui/splashscreenView/splashscreen_view.dart' as _i15;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    ProfileView.name: (routeData) {
      final args = routeData.argsAs<ProfileViewArgs>(
          orElse: () => const ProfileViewArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ProfileView(key: args.key),
      );
    },
    RecipeDetailsView.name: (routeData) {
      final args = routeData.argsAs<RecipeDetailsViewArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.RecipeDetailsView(
          key: args.key,
          recipe: args.recipe,
        ),
      );
    },
    MyRecipesView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.MyRecipesView(),
      );
    },
    RecipeSearchView.name: (routeData) {
      final args = routeData.argsAs<RecipeSearchViewArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.RecipeSearchView(
          key: args.key,
          searchTerm: args.searchTerm,
        ),
      );
    },
    ShoppingView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ShoppingView(),
      );
    },
    PantryView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.PantryView(),
      );
    },
    PantryCatalogView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.PantryCatalogView(),
      );
    },
    NavigationView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.NavigationView(),
      );
    },
    ForgotPasswordView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ForgotPasswordView(),
      );
    },
    DietPreferencesView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.DietPreferencesView(),
      );
    },
    RecommendationPreferences.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.RecommendationPreferences(),
      );
    },
    RecipePreferencesView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.RecipePreferencesView(),
      );
    },
    RegisterView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.RegisterView(),
      );
    },
    LoginView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.LoginView(),
      );
    },
    SplashRouteView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.SplashScreenView(),
      );
    },
    HomeView.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.OldHomeView(),
      );
    },
  };
}

/// generated route for
/// [_i1.ProfileView]
class ProfileView extends _i17.PageRouteInfo<ProfileViewArgs> {
  ProfileView({
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          ProfileView.name,
          args: ProfileViewArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ProfileView';

  static const _i17.PageInfo<ProfileViewArgs> page =
      _i17.PageInfo<ProfileViewArgs>(name);
}

class ProfileViewArgs {
  const ProfileViewArgs({this.key});

  final _i18.Key? key;

  @override
  String toString() {
    return 'ProfileViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.RecipeDetailsView]
class RecipeDetailsView extends _i17.PageRouteInfo<RecipeDetailsViewArgs> {
  RecipeDetailsView({
    _i18.Key? key,
    required _i19.Recipe recipe,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          RecipeDetailsView.name,
          args: RecipeDetailsViewArgs(
            key: key,
            recipe: recipe,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeDetailsView';

  static const _i17.PageInfo<RecipeDetailsViewArgs> page =
      _i17.PageInfo<RecipeDetailsViewArgs>(name);
}

class RecipeDetailsViewArgs {
  const RecipeDetailsViewArgs({
    this.key,
    required this.recipe,
  });

  final _i18.Key? key;

  final _i19.Recipe recipe;

  @override
  String toString() {
    return 'RecipeDetailsViewArgs{key: $key, recipe: $recipe}';
  }
}

/// generated route for
/// [_i3.MyRecipesView]
class MyRecipesView extends _i17.PageRouteInfo<void> {
  const MyRecipesView({List<_i17.PageRouteInfo>? children})
      : super(
          MyRecipesView.name,
          initialChildren: children,
        );

  static const String name = 'MyRecipesView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.RecipeSearchView]
class RecipeSearchView extends _i17.PageRouteInfo<RecipeSearchViewArgs> {
  RecipeSearchView({
    _i18.Key? key,
    required String searchTerm,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          RecipeSearchView.name,
          args: RecipeSearchViewArgs(
            key: key,
            searchTerm: searchTerm,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeSearchView';

  static const _i17.PageInfo<RecipeSearchViewArgs> page =
      _i17.PageInfo<RecipeSearchViewArgs>(name);
}

class RecipeSearchViewArgs {
  const RecipeSearchViewArgs({
    this.key,
    required this.searchTerm,
  });

  final _i18.Key? key;

  final String searchTerm;

  @override
  String toString() {
    return 'RecipeSearchViewArgs{key: $key, searchTerm: $searchTerm}';
  }
}

/// generated route for
/// [_i5.ShoppingView]
class ShoppingView extends _i17.PageRouteInfo<void> {
  const ShoppingView({List<_i17.PageRouteInfo>? children})
      : super(
          ShoppingView.name,
          initialChildren: children,
        );

  static const String name = 'ShoppingView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.PantryView]
class PantryView extends _i17.PageRouteInfo<void> {
  const PantryView({List<_i17.PageRouteInfo>? children})
      : super(
          PantryView.name,
          initialChildren: children,
        );

  static const String name = 'PantryView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.PantryCatalogView]
class PantryCatalogView extends _i17.PageRouteInfo<void> {
  const PantryCatalogView({List<_i17.PageRouteInfo>? children})
      : super(
          PantryCatalogView.name,
          initialChildren: children,
        );

  static const String name = 'PantryCatalogView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i8.NavigationView]
class NavigationView extends _i17.PageRouteInfo<void> {
  const NavigationView({List<_i17.PageRouteInfo>? children})
      : super(
          NavigationView.name,
          initialChildren: children,
        );

  static const String name = 'NavigationView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ForgotPasswordView]
class ForgotPasswordView extends _i17.PageRouteInfo<void> {
  const ForgotPasswordView({List<_i17.PageRouteInfo>? children})
      : super(
          ForgotPasswordView.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.DietPreferencesView]
class DietPreferencesView extends _i17.PageRouteInfo<void> {
  const DietPreferencesView({List<_i17.PageRouteInfo>? children})
      : super(
          DietPreferencesView.name,
          initialChildren: children,
        );

  static const String name = 'DietPreferencesView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.RecommendationPreferences]
class RecommendationPreferences extends _i17.PageRouteInfo<void> {
  const RecommendationPreferences({List<_i17.PageRouteInfo>? children})
      : super(
          RecommendationPreferences.name,
          initialChildren: children,
        );

  static const String name = 'RecommendationPreferences';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.RecipePreferencesView]
class RecipePreferencesView extends _i17.PageRouteInfo<void> {
  const RecipePreferencesView({List<_i17.PageRouteInfo>? children})
      : super(
          RecipePreferencesView.name,
          initialChildren: children,
        );

  static const String name = 'RecipePreferencesView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i13.RegisterView]
class RegisterView extends _i17.PageRouteInfo<void> {
  const RegisterView({List<_i17.PageRouteInfo>? children})
      : super(
          RegisterView.name,
          initialChildren: children,
        );

  static const String name = 'RegisterView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i14.LoginView]
class LoginView extends _i17.PageRouteInfo<void> {
  const LoginView({List<_i17.PageRouteInfo>? children})
      : super(
          LoginView.name,
          initialChildren: children,
        );

  static const String name = 'LoginView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SplashScreenView]
class SplashRouteView extends _i17.PageRouteInfo<void> {
  const SplashRouteView({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRouteView.name,
          initialChildren: children,
        );

  static const String name = 'SplashRouteView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.OldHomeView]
class HomeView extends _i17.PageRouteInfo<void> {
  const HomeView({List<_i17.PageRouteInfo>? children})
      : super(
          HomeView.name,
          initialChildren: children,
        );

  static const String name = 'HomeView';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}
