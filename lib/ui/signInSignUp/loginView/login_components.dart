import 'package:flutter/material.dart';
import 'package:qookit/app/app_router.gr.dart';
import '../forgotPasswordView/forgot_password_view.dart';
import '../registerView/register_view.dart';
import 'package:qookit/ui/signInSignUp/loginView/login_view_model.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordButton extends ViewModelWidget<LoginViewModel> {
  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 20),
          child: InkWell(
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'opensans',
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.amber,
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            onTap: () {
              // ExtendedNavigator.named('topNav')?.push(Routes.forgotPasswordView);
              model.navigateToForgotPassword(context);
            },
          ),
        ),
      ],
    );
  }
}

class NoAccountRow extends ViewModelWidget<LoginViewModel> {
  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Don't have an Account?",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              // fontWeight: FontWeight.w600,
              fontFamily: 'opensans',
            ),
          ),
        ),
        InkWell(
          child: Padding(
            child: Column(
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.transparent,
                      shadows: [Shadow(offset: Offset(0, -5))],
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'opensans',
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationColor: Colors.amber),
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
          ),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
            /*context.router.push(PageRouteInfo(
              'RegisterView.dart',
              path: '../registerView/register_view.dart',
            ));*/
            // ExtendedNavigator.named('topNav')?.replace(Routes.registerView);
            model.navigateToSignUp(context);
          },
        )
      ],
    );
  }
}

class ThirdPartyIcons extends ViewModelWidget<LoginViewModel> {
  ThirdParty google =
      ThirdParty(image: 'assets/images/v2/app_logo.png', label: 'Google');

  @override
  Widget build(BuildContext context, model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SingleIcon(google, model),
      ],
    );
  }

  Widget SingleIcon(ThirdParty party, LoginViewModel model) {
    return Builder(
      builder: (context) => InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Image.asset(
              party.image,
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
        onTap: () {
          switch (party.label) {
            case 'Google':
              model.loginWithGoogle(context);
              break;
          }
        },
      ),
    );
  }
}

class ThirdParty {
  String image;
  String label;

  ThirdParty({required this.image,required this.label});
}
