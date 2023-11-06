import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/ui/navigationView/drawer/drawer_view.dart';
import 'package:qookit/ui/navigationView/navigation_view_model.dart';
import 'package:stacked/stacked.dart';

import 'package:auto_route/annotations.dart';

@RoutePage()
class NavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
        viewModelBuilder: () => NavigationViewModel(),
        onModelReady: (model) => model.initializeModel(),
        builder: (context, model, child) {
          NavigationObserver observer = NavigationObserver(model);

          return WillPopScope(
            onWillPop: () => model.onWillPop(context),
            child: Scaffold(
              extendBody: true,
              drawer: NavDrawer(),
              body: ExtendedNavigator(
                router: NavigationViewRouter(),
                initialRoute: model.screenId,
                name: 'nestedNav',
                observers: [observer],
              ),
              floatingActionButton: model.hideNav
                  ? null
                  : FloatingActionButton(
                      key: model.fabKey,
                      backgroundColor: Colors.amber,
                      onPressed: () {
                        if (!model.showOverlay) {
                          model.updateOverlay(true);
                          if(model.firstFabOverlay != null) Overlay.of(context).insert(model.firstFabOverlay!);
                        } else {
                          model.updateOverlay(false);
                          model.fabOverlay?.remove();
                        }
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                                'assets/images/v2/app_logo.svg',
                                color: Colors.black),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                                'assets/images/v2/app_logo.svg',
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: model.hideNav
                  ? null
                  : BottomAppBar(
                      shape: CircularNotchedRectangle(),
                      notchMargin: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomIcon(model.navItems[0], 0, model),
                          BottomIcon(model.navItems[1], 1, model),
                          SizedBox(height: 40, width: 35),
                          BottomIcon(model.navItems[2], 2, model),
                          BottomIcon(model.navItems[3], 3, model),
                        ],
                      ),
                    ),
            ),
          );
        });
  }

  Widget BottomIcon(BottomItem item, int index, NavigationViewModel model) {
    return Flexible(
      // child: ElevatedButton(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // clipBehavior: Clip.none,
      // splashColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      // onPressed: () => model.onItemTapped(index),
      child: GestureDetector(
        onTap: () => model.onItemTapped(index),
        child: Container(
          // color: Colors.cyan,
          margin: EdgeInsets.symmetric(vertical: 8),
          // height: 50,
          // width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                item.assetIcon,
                color:
                    model.selectedIndex == index ? Colors.amber : Colors.black,
              ),
              // Padding(
              // padding: const EdgeInsets.only(top: 2.0),
              // child: FittedBox(
              // fit: BoxFit.scaleDown,
              // child:
              Text(
                item.label,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'opensans ',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: model.selectedIndex == index
                      ? Colors.amber
                      : Colors.black,
                  // ),

                  // GoogleFonts.lato(
                  //   fontSize: 14,
                  //   color: model.selectedIndex == index
                  //       ? Colors.amber
                  //       : Colors.black,
                  // ),
                  // ),
                ),
              )
            ],
            // ),
          ),
        ),
      ),
    );
  }
}

class NavigationViewRouter extends RouterBase{
  @override
  // TODO: implement pagesMap
  Map<Type, StackedRouteFactory> get pagesMap => throw UnimplementedError();

  @override
  // TODO: implement routes
  List<RouteDef> get routes => throw UnimplementedError();

}
