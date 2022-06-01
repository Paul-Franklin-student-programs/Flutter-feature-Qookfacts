
import 'package:flutter/material.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/bloc/user_bloc.dart';
import 'package:qookit/services/services.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_lwa_platform_interface/flutter_lwa_platform_interface.dart';


class LoginViewModel extends BaseViewModel {

  String email;
  String password;
  String confirmPassword;
  String name;
  bool showPassword = false;
  bool confirmShowPassword = false;
  bool passwordVisible = false;

  LwaAuthorizeResult lwaAuth;

  GlobalKey<ScaffoldState> scaffoldKey;
  var globalKey;

  FocusNode focusNumber = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode pinPutFocusNode = FocusNode();
  FocusNode focusEmailId = FocusNode();
  FocusNode focusName = FocusNode();
  FocusNode focusConfirmPassword = FocusNode();

  final TextEditingController pinPutController = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmailId = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();
  final TextEditingController txtEmailIDForgotPassword =
      TextEditingController();

  String receivedOtp = '';
  String receivedUserId = '';
  Function callback;
  Function callbackOpenPasswordChangedDialog;

  void init(callback1, callback2) {
    callback = callback1;
    callbackOpenPasswordChangedDialog = callback2;
  }

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updatePassword(String newPass) {
    password = newPass;
    notifyListeners();
  }

  void updateConfirm(String newPass) {
    confirmPassword = newPass;
    notifyListeners();
  }

  RegisterController() {
   scaffoldKey = GlobalKey<ScaffoldState>();
  }

  LoginController() {
   scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleShowConfirmPassword() {
    confirmShowPassword = !confirmShowPassword;
    notifyListeners();
  }

  void passwordToggle() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }


  Future<void> loginWithEmail(BuildContext context) async {
    String message = await authService.signInWithEmail(context, email, password);
    if (message == 'Success') {
      await UserBloc().getUserData();
      await ExtendedNavigator.named('topNav').pushAndRemoveUntil(Routes.splashScreenView, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));

    }
  }

  ///login with Google and stored credential in firebase
  Future<void> loginWithGoogle(BuildContext context) async {
    String message = await authService.signInWithGoogle();
    /*await UserBloc().getUserData();
    await loginNavigation(message, context);*/
    if(message == 'Success'){
      await UserBloc().getUserData();
      await loginNavigation(message, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }

  ///login with Facebook and stored credential in firebase
  Future<void> loginWithFacebook(BuildContext context) async {
    String message = await authService.initiateFacebookLogin();

    if(message == 'Success'){
      await UserBloc().getUserData();
      await loginNavigation(message, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }

  ///Register user with email-password and stored in firebase
  Future<void> signUpWithEmail(BuildContext context) async {
    String message =await authService.signUpWithEmail(context, email, password, name);
    if(message == 'Success'){
      await UserBloc().getUserData();
      await loginNavigation(message, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }

  ///Registration and Sign in with amazon
  Future<void> loginWithAmazon(BuildContext context) async {
    String message = await authService.signInWithAmazon(context);
    /*await UserBloc().getUserData();
    await loginNavigation(message, context);*/
    if(message == 'Success'){
      await UserBloc().getUserData();
      await loginNavigation(message, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }


  Future<void> loginWithApple(BuildContext context) async {
    String message = await authService.signInWithApple(context);
    /*await UserBloc().getUserData();
    await loginNavigation(message, context);*/
    if(message == 'Success'){
      await UserBloc().getUserData();
      await loginNavigation(message, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }

  Future<void> loginNavigation(String message, BuildContext context) async {
    if (message == 'Success') {
      await ExtendedNavigator.named('topNav')
          .pushAndRemoveUntil(Routes.splashScreenView, (route) => true);
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
      ));
    }
  }
}
