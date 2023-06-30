// Service for handling app navigation


import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:injectable/injectable.dart';

import '../../ui/navigationView/navigation_view_model.dart';
import '../../ui/signInSignUp/loginView/login_view.dart';

@singleton
class NavigationService {

  static NavigationService instance = NavigationService();
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  /*NavigationService(){
    navigationKey = GlobalKey<NavigatorState>();
    log('navigationKey: ${navigationKey.toString()}');
  }*/

  Future<dynamic> navigateToReplacement(String _rn) async {
    if(navigationKey.currentState != null){
      return navigationKey.currentState!.pushReplacementNamed(_rn);
    }else{
      await Future.delayed(Duration(milliseconds: 100)).then((value) {
        return '';
      });
    }
  }
  Future<dynamic> navigateTo(String _rn){
    return navigationKey.currentState!.pushNamed(_rn);
  }


  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) async {
    if(navigationKey.currentState != null){
      log('context found: ${navigationKey.toString()}');
      return navigationKey.currentState!.push(_rn);
    }else{
      log('no context found: ${navigationKey.toString()}');
      log('navigationKey: ${navigationKey.toString()}');
      await Future.delayed(Duration(milliseconds: 100)).then((value) {
        return '';
      });
    }
  }

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GetIt locator = GetIt.instance;


  /*dynamic navigateToScreen(WidgetBuilder ScreenName) {
    // return navigateTo((context) => ScreenName(context));
    log('navigatorKey.currentState: ${navigatorKey.toString()}');
    if(navigatorKey.currentState != null){
      // return Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (_) => ScreenName(navigatorKey.currentState!.context)));
      return navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => ScreenName(navigatorKey.currentState!.context)));
    }else{
      print('no context found !!!!!!!');
      return 0;
    }
  }*/

  void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }


  List<String> hideNavBar = [
    NavigationViewRoutes.cameraView,
    NavigationViewRoutes.recipeSearchView,
    NavigationViewRoutes.pantryCatalogView,
  ];
}
