import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qookit/models/expiry_group.dart';
import 'package:qookit/models/pantry_item.dart';
import 'package:qookit/services/getIt.dart';
import 'package:qookit/services/ml/ml_service.dart';
import 'package:qookit/services/navigation/navigation_service.dart';
import 'package:qookit/services/services.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/tflite_test/ui/home_view.dart';
import 'package:qookit/ui/signInSignUp/forgotPasswordView/forgot_password_view.dart';
import 'package:qookit/ui/signInSignUp/loginView/login_view.dart';
import 'package:qookit/ui/signInSignUp/registerView/register_view.dart';
import 'package:qookit/ui/splashscreenView/splashscreen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/app_router.dart';
import 'models/itemlist.dart';
import 'ui/signInSignUp/onboardingView/dietPreferences/diet_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recommendationPreferences/recommendation_preferences_view.dart';

bool preview = false;

Future<void> main() async {
  // NavigationService().setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();

  // unawaited(mlService.setupModel());

  MlService.firebasemodeldownloder();
  MlService.downloadlabelfile();

  /// Initialize hive stuff
  await Hive.initFlutter();
  Hive.registerAdapter(PantryItemAdapter());
  Hive.registerAdapter(ExpiryGroupAdapter());
  Hive.registerAdapter(ItemListAdapter());

  await Hive.openBox('master');
  await Hive.box('master').put('ready', false);

  /// Initialize stacked themes
  await ThemeManager.initialise();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.top,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
        darkTheme: qookitDark,
        lightTheme: qookitLight,
        defaultThemeMode: ThemeMode.light,
        builder: (context, regularTheme, darkTheme, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: regularTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            color: (kIsWeb) ? Colors.green : Colors.red,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => SplashScreenView());
                case '/login':
                  return MaterialPageRoute(builder: (_) => LoginView());
                case '/forgot-password-view':
                  return MaterialPageRoute(
                      builder: (_) => ForgotPasswordView());
                case '/diet-preferences-view':
                  return MaterialPageRoute(
                      builder: (_) => DietPreferencesView());
                case '/recipe-preferences-view':
                  return MaterialPageRoute(
                      builder: (_) => RecipePreferencesView());
                case '/recommendation-preferences-view':
                  return MaterialPageRoute(
                      builder: (_) => RecommendationPreferences());
                case '/register':
                  return MaterialPageRoute(builder: (_) => RegisterView());
                case '/home-view':
                  return MaterialPageRoute(builder: (_) => HomeView());
                default:
                  return null; // Handle other routes or show a default screen
              }
            },
            showSemanticsDebugger: false,

            /*builder: (context, nativeNavigator) {
              return ExtendedNavigator.builder<AppRouter>(
                  initialRoute: '/login-view',
                  router: AppRouter(),
                  name: 'topNav',
                  builder: (context, child) {
                    return child ?? Container();
                  },
              )
                (context, nativeNavigator);
            },*/
          );
        });
  }
}
