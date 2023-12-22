import 'dart:developer' as d;

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/navigation/navigation_service.dart';
import '../../ui/signInSignUp/loginView/login_view.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
// import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/ui/signInSignUp/loginView/login_view.dart';
import 'package:qookit/ui/splashscreenView/splashscreen_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_route/annotations.dart';


@RoutePage()
class SplashScreenView extends StatelessWidget {
  List<Slide> slides = [];

  // Function goToTab;

  final List<String> imgList = [
    'assets/images/v2/app_logo.png',
    'assets/images/v2/app_logo.png',
    'assets/images/v2/app_logo.png',
  ];

  final List<String> txtList = [
    'Meal Planning in 60 Seconds',
    'Your Pantry in your Pocket',
    'Recipes Based On Your Goals',
  ];

  @override
  Widget build(BuildContext context) {
    // return Container();
    return ViewModelBuilder<SplashScreenViewModel>.reactive(
      viewModelBuilder: () => SplashScreenViewModel(),
      onModelReady: (model) async => await model.initialize(),
      builder: (ctx, model, builder) => Scaffold(
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          model.updateTitle(index);
                        },
                      ),
                      items: imgList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: ExactAssetImage(i),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container());
                          },
                        );
                      }).toList(),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 10),
                              child: Text(
                                'Qookit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  // fontSize:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'georgia_bold',
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 10),
                              child: Text(
                                txtList[model.titlePositon],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'opensans',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                            ),
                            GetStartedButton(context, model),
                            SizedBox(
                              height: 15,
                            ),
                            LoginButton(context, model),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: InkWell(
                                child: IgnorePointer(
                                  child: Text(
                                    'Maybe Later',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'opensans'),
                                  ),
                                ),
                                onTap: () {
                                  // ExtendedNavigator.named('topNav')
                                  //     ?.push(Routes.loginView);
                                  // context.router.push(PageRouteInfo('Home',path: 'logIn'));
                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginView()));
                                  // model.navigateToHomeScreenScreen(context);
                                  model.navigateToLogInScreen(
                                    context: context,
                                    );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget GetStartedButton(BuildContext context,SplashScreenViewModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5, right: 10),
      child: InkWell(
        splashFactory: InkSplash.splashFactory,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.amber, border: Border.all(color: Colors.white)),
          width: 250,
          height: 45,
          child: Center(
            child: Text(
              'GET STARTED',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'opensans_bold',
              ),
            ),
          ),
        ),
        onTap: () {
          // context.router.push(PageRouteInfo('RegisterView.dart', path: '../../ui/signInSignUp/registerView/register_view.dart'));
          // ExtendedNavigator.named('topNav')?.push(Routes.registerView);
          model.navigateToRegisterScreen(context);
        },
      ),
    );
  }

  Widget LoginButton(BuildContext ctx, SplashScreenViewModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5, right: 10),
      child: InkWell(
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.amber)),
            width: 250,
            height: 45,
            child: Center(
              child: Text(
                'LOG IN',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'opensans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          d.log('login clicked !!!!!!!!!');
          // ExtendedNavigator.named('topNav')?.push(Routes.loginView);
          // context.router.push(PageRouteInfo('LoginView.dart', path: '/login'));
          // navigatorKey.currentState?.pushNamed('/your_route_name');
          // navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => LoginView() ));

          // Navigator.push(ctx, MaterialPageRoute(builder: (_)=>LoginView()));
          // await navigatorKey.navigateToRoute(MaterialPageRoute(builder: (_) => LoginView()));
          // await NavigationService.instance.navigateToRoute(MaterialPageRoute(builder: (_) => LoginView()));
          // Navigator.push(ctx, MaterialPageRoute(builder: (context) => LoginView()));
          model.navigateToLogInScreen(
            context: ctx,);
          d.log('After');

        },
      ),
    );
  }
}
