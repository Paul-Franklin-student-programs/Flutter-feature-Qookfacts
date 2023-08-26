
import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/services/getIt.dart';
import 'package:qookit/services/services.dart';
import 'package:qookit/services/user/user_service.dart';
import 'package:stacked/stacked.dart';

class SplashScreenViewModel extends BaseViewModel {
  int imgPosition = 0;
  int titlePositon = 0;

  Future<void> initialize() async {
    if (authService.user != null) {
      setBusy(true);

      await initializeServices();
      await hiveService.setupHive();
      await userService.initializeUser();

      /// User has already finished onboarding
      if (hiveService.userBox.get(
        UserService.finishedOnboarding,
        defaultValue: false,
      )) {
        // await ExtendedNavigator.named('topNav')?.pushAndRemoveUntil(
        //   Routes.navigationView,
        //   (route) => false,
        // );
      }

      /// User still needs to finish onboarding
      else {
        // await ExtendedNavigator.named('topNav')?.pushAndRemoveUntil(
        //   Routes.recommendationPreferences,
        //   (route) => false,
        // );
      }

      setBusy(false);
    } else {
      // stay
    }
  }

  void updatePositon(int newPos) {
    imgPosition = newPos;
    notifyListeners();
  }

  void updateTitle(int newPos) {
    titlePositon = newPos;
    notifyListeners();
  }

  void navigateToLogInScreen({
    required BuildContext context,

  }) {
    Navigator.pushNamed(
        context,
        '/login',
    );
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void navigateToHomeScreenScreen(BuildContext context) {
    Navigator.pushNamed(context, '/homeScreen');
  }

}
