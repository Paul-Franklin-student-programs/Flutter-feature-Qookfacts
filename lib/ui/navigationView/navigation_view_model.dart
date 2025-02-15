import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qookit/app/app_router.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/services/services.dart';
import 'package:qookit/services/user/user_service.dart';
import 'package:qookit/ui/navigationView/navigation_widgets.dart';
import 'package:stacked/stacked.dart';

import '../../app/app_router.gr.dart';

class NavigationViewModel extends BaseViewModel {
  final navigatorKey = GlobalKey<NavigatorState>();
  String screenId = '';
  int selectedIndex = 0; // The current page selected by the user
  bool initiated = false;

  bool showOverlay = false;
  GlobalKey fabKey = GlobalObjectKey('fab');

  OverlayEntry? fabOverlay;

  OverlayEntry? get firstFabOverlay {
    if(fabKey.currentContext != null){
      fabOverlay = showFabActions(fabKey.currentContext!, this);
    }
    return fabOverlay;
  }

  void initializeModel() {
    screenId = hiveService.userBox.get(
      UserService.lastScreen
    ); //defaultValue: PantryView.id);
    // selectedIndex = routeMap.indexOf(screenId);
  }

  bool get hideNav {
    if (navigationService.hideNavBar.contains(screenId)) {
      return true;
    } else {
      return false;
    }
  }

  // Route map specifically for the navigator view nav bar
  // Index matches up to screen
  List<String> routeMap = [
    NavigationViewRoutes.pantryView,
    NavigationViewRoutes.recipesView,
    NavigationViewRoutes.shoppingView,
    NavigationViewRoutes.profileView,
  ];

  List<BottomItem> navItems = [
    BottomItem('pantry', FontAwesomeIcons.breadSlice, 'assets/images/v2/app_logo.svg'),
    BottomItem('recipes', FontAwesomeIcons.utensils, 'assets/images/v2/app_logo.svg'),
    BottomItem('shopping', FontAwesomeIcons.shoppingCart, 'assets/images/v2/app_logo.svg'),
    BottomItem('profile', FontAwesomeIcons.userAlt, 'assets/images/v2/app_logo.svg'),
  ];

  void onItemTapped(int index) {
    if (index == selectedIndex) {
      // Don't update tab if it matches the current tab
      print('Same tab selected');

    } else {
      selectedIndex = index;
      // screenId = routeMap[selectedIndex];
      hiveService.userBox.put(UserService.lastScreen, screenId);
      // print('Index: $index Route: ${routeMap[selectedIndex]} ScreenID: $screenId');
      ExtendedNavigator.named('nestedNav')?.push(screenId);
      notifyListeners();
    }
  }

  void updateSelectedItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateScreen(String screen) {
    screenId = screen;
    notifyListeners();
  }

  void updateOverlay(bool show) {
    showOverlay = show;
    notifyListeners();
  }

  void initiateNavigator() {
    initiated = true;
  }

  // Override pop action inside nested navigator so it
  // only changes tabs and does not close app
  Future<bool> onWillPop(BuildContext context) async {
    print('on will POP');
    // If the nested navigator can pop, pop
    if (navigatorKey.currentState != null && navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      return false;
    }
    // Else exit app (after approval)
    else {
      bool isPop = false;
      await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the App?'),
              actions: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ).then((value) {
            return false;
      });
      return false;
    }
  }
}

class NavigationViewRoutes {
  static var cameraView = 'cameraView';
  static var recipeSearchView = 'recipeSearchView';
  static var pantryCatalogView = 'pantryCatalogView';

  static var pantryView = 'pantryView';
  static var recipesView = 'recipesView';
  static var shoppingView = 'shoppingView';
  static var profileView = 'profileView';
}

class BottomItem {
  final String label;
  final IconData icon;
  final String assetIcon;

  BottomItem(this.label, this.icon, this.assetIcon);
}

class NavigationObserver extends RouteObserver {
  NavigationObserver(this.model);

  final NavigationViewModel model;

  @override
  void didReplace({Route? newRoute,Route? oldRoute}) {
    // print('replace');
    super.didReplace();
    var newIndex = getNewIndex(newRoute!.settings.name ?? '');
    // print('new index: ${newRoute.settings.name}');
    model.updateSelectedItem(newIndex);
    model.updateScreen(newRoute.settings.name ?? '');
  }

  // Update the nav bar index based on the current route
  @override
  void didPop(Route? route, Route? previousRoute) {
    print('Route: ${route!.settings.name}');
    print('Previous: ${previousRoute!.settings.name}');
    print('Nested nav pop');
    int newIndex = getNewIndex(previousRoute.settings.name ?? '');
    model.updateSelectedItem(newIndex);
    model.updateScreen(previousRoute.settings.name ?? '');
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route? route, Route? previousRoute) {
    print('');
    // Don't rebuild model the first time it opens...causes crash
    if (model.initiated) {
      int newIndex = getNewIndex(route?.settings.name ?? '');
      print('new index: ${route?.settings.name}');
      model.updateSelectedItem(newIndex);
      model.updateScreen(route?.settings.name ?? '');
    } else {
      model.initiateNavigator();
    }
    super.didPush(route!, previousRoute);
  }

  int getNewIndex(String routeName) {
    int newIndex = 0;
    switch (routeName) {
      case 'PantryView.dart':
        newIndex = 0;
        break;
      case 'RecipesView.dart':
        newIndex = 1;
        break;
      case 'ShoppingView.dart':
        newIndex = 2;
        break;
      case 'ProfileView.dart':
        newIndex = 3;
        break;
    }
    return newIndex;
  }
}