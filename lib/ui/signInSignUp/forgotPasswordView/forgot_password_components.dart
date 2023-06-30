import 'package:flutter/material.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/elements/block_button_widget.dart';
import 'package:qookit/ui/signInSignUp/forgotPasswordView/forgot_password_view_model.dart';
import 'package:stacked/stacked.dart';

class SendEmailButton extends ViewModelWidget<ForgotPasswordViewModel> {
  final GlobalKey<FormState> _loginFormKey;

  SendEmailButton(this._loginFormKey);

  @override
  Widget build(BuildContext context, model) {
    return Builder(
      builder: (context) => BlockButtonWidget(
        text: 'SEND EMAIL',
        color: Colors.black,
        onPressed: () {
          if (_loginFormKey.currentState?.validate() ?? false) {
            model.sendResetPasswordEmail(context);
          }
        },
      ),
    );
  }
}

class BackToLoginButton extends ViewModelWidget<ForgotPasswordViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Builder(
      builder: (context) => BlockButtonWidget(
        text: 'LOG IN',
        color: Colors.black,
        onPressed: () {
          context.router.push(PageRouteInfo(
            'LoginView.dart',
            path: '../loginView/login_components.dart',
          ));
          // ExtendedNavigator.named('topNav')?.pop(Routes.loginView);
        },
      ),
    );
  }
}

class ForgotPassMessage extends ViewModelWidget<ForgotPasswordViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Padding(
          child: Text(
            model.emailMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'opensans',
            ),
          ),
          padding: EdgeInsets.only(left: 20, right: 20),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
