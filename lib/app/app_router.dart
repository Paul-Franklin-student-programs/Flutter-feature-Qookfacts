// import 'package:auto_route/auto_route.dart';
// import '../tflite_test/ui/old_home_view.dart';
// import '../ui/navigationView/navigation_view.dart';
// import '../ui/navigationView/pantryView/pantryCatalog/pantry_catalog_view.dart';
// import '../ui/navigationView/pantryView/pantry_view.dart';
// import '../ui/navigationView/profileView/profile_view.dart';
// import '../ui/navigationView/recipesView/recipeDetails/recipe_details_view.dart';
// import '../ui/navigationView/recipesView/recipeSearch/recipe_search_view.dart';
// import '../ui/navigationView/recipesView/recipes_view.dart';
// import '../ui/navigationView/settingsView/settings_view.dart';
// import '../ui/navigationView/shoppingView/shopping_view.dart';
// import '../ui/signInSignUp/forgotPasswordView/forgot_password_view.dart';
// import '../ui/signInSignUp/loginView/login_view.dart';
// import '../ui/signInSignUp/onboardingView/dietPreferences/diet_preferences_view.dart';
// import '../ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view.dart';
// import '../ui/signInSignUp/registerView/register_view.dart';
// import '../ui/splashscreenView/splashscreen_view.dart';
// import 'app_router.gr.dart';
//
// /*@AdaptiveAutoRouter(
//   routes: <AutoRoute>[
//   // initial route is named "/"
//     AdaptiveRoute(page: SplashScreenView,initial: true),
//     AdaptiveRoute(page: LoginView),
//     AdaptiveRoute(page: ForgotPasswordView),
//     AdaptiveRoute(page: DietPreferencesView),
//     AdaptiveRoute(page: RecipePreferencesView),
//     AdaptiveRoute(page: RecommendationPreferences,),
//     AdaptiveRoute(page: RegisterView,),
//     AdaptiveRoute(page: NavigationView,
//     children: [
//       AdaptiveRoute(page: HomeView,),
//       AdaptiveRoute(page: ProfileView,),
//       AdaptiveRoute(page: PantryView, initial: true),
//       AdaptiveRoute(page: PantryCatalogView,),
//       AdaptiveRoute(page: RecipesView,),
//       AdaptiveRoute(page: RecipeSearchView,),
//       AdaptiveRoute(page: RecipeDetailsView,),
//       AdaptiveRoute(page: SettingsView,),
//       AdaptiveRoute(page: ShoppingView,),
//     ]),
//   ],
// )
// class $AppRouter {}*/
//
// // Updated code
//
// @AutoRouterConfig()
// class AppRouter extends $AppRouter{
//   AppRouter();
//
//   @override
//   List<AutoRoute> get routes => [
//     AdaptiveRoute(
//       page: PageInfo('SplashScreenView'),
//       path: '/'
//     ),
//     AdaptiveRoute(
//        page: PageInfo('LoginView'),
//        path: '/login',
//     ),
//     AdaptiveRoute(
//        page: PageInfo('ForgotPasswordView'),
//        path: '/forgotPassword',
//     ),
//     AdaptiveRoute(
//        page: PageInfo('DietPreferencesView'),
//        path: '/dietPrefs',
//     ),
//     AdaptiveRoute(
//         page: PageInfo('RecipePreferencesView'),
//        path: '/recipePrefs',
//     ),
//     AdaptiveRoute(
//       page: PageInfo('RecommendationPreferences'),
//       path: '/recPrefs'
//     ),
//     AdaptiveRoute(
//       page: PageInfo('RegisterView'),
//       path: '/registerView',
//     ),
//     AdaptiveRoute(
//         page: PageInfo('NavigationView'),
//         path: '/navView',
//         children: [
//           AdaptiveRoute(
//             page: PageInfo('HomeView'),
//             path: 'homeView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('ProfileView'),
//             path: 'profileView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('PantryView'),
//             path: 'pantryView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('PantryCatalogView'),
//             path: 'PantryCatView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('RecipesView'),
//             path: 'recipeView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('RecipeSearchView'),
//             path: 'recipeSearchView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('RecipeDetailsView'),
//             path: 'recipeDetaileView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('SettingsView'),
//             path: 'settingsView',
//           ),
//           AdaptiveRoute(
//             page: PageInfo('ShoppingView'),
//             path: 'shoppingView',
//           ),
//         ]),
//   ];
// }
