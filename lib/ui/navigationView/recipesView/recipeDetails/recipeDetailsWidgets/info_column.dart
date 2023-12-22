import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qookit/models/ingredient.dart';
import 'package:qookit/ui/navigationView/recipesView/recipeDetails/recipe_details_view_model.dart';
import 'package:stacked/stacked.dart';

class InfoColumn extends ViewModelWidget<RecipeDetailsViewModel> {
  @override
  Widget build(BuildContext context, RecipeDetailsViewModel model) {
    if (model.selectedTab == 'ingredients') {
      return Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ITEMS YOU NEED',
                      style: TextStyle(
                          fontFamily: 'lato_bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 15)

                      // GoogleFonts.openSans(
                      //     fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                ),
              ],
            ),
            trailing: TextButton(
              child: Text('SELECT ALL',
                  style: TextStyle(
                      fontFamily: 'lato_regular',
                      fontWeight: FontWeight.w400,
                      color: Colors.black)

                  //  GoogleFonts.openSans(
                  //     fontWeight: FontWeight.w300, color: Colors.black),
                  ),
              onPressed: () {
                model.addAllNeeded();
              },
            ),
          ),
          for (Ingredient ing in model.neededIngredients)
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ing.quantity.toString() ?? '',
                      style: GoogleFonts.openSans(fontSize: 15)),
                  Text(ing.unit ?? '',
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                      )),
                ],
              ),
              onTap: () {
                model.toggleItem(ing);
              },
              title: Text(
                ing.text,
                style: GoogleFonts.openSans(
                  fontSize: 15,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  model.toggleItem(ing);
                },
                icon: !model.added.contains(ing.text)
                    ? SvgPicture.asset(
                        'assets/images/v2/app_logo.svg')
                    : SvgPicture.asset(
                        'assets/images/v2/app_logo.svg'),
              ),
            ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fastfood_outlined),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('IN YOUR PANTRY',
                      style: TextStyle(
                          fontFamily: 'lato_bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 15)

                      //  GoogleFonts.openSans(
                      //     fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                ),
              ],
            ),
            trailing: TextButton(
              child: Text('RESTOCK ALL',
                  style: TextStyle(
                      fontFamily: 'lato_regular',
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 13)

                  //  GoogleFonts.openSans(
                  //     fontSize: 13,
                  //     fontWeight: FontWeight.w300,
                  //     color: Colors.black
                  //     ),
                  ),
              onPressed: () {
                model.addAllPantry();
              },
            ),
          ),
          for (Ingredient ing in model.pantryIngredients)
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ing.quantity.toString(),
                      style: TextStyle(
                          fontFamily: 'lato_bold',
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0)),
                  Text(ing.unit,
                      style: TextStyle(
                          fontFamily: 'lato_bold',
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0))
                ],
              ),
              onTap: () {
                model.toggleItem(ing);
              },
              title: Text(ing.text,
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                  )),
              trailing: IconButton(
                onPressed: () {
                  model.toggleItem(ing);
                },
                icon: !model.added.contains(ing.text)
                    ? SvgPicture.asset(
                        'assets/images/v2/app_logo.svg')
                    : SvgPicture.asset(
                        'assets/images/v2/app_logo.svg'),
              ),
            ),
        ],
      );
    } else {
      return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28.0,
                  //color: Colors.cyan,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          fontFamily: 'georgia_bold',
                          fontWeight: FontWeight.w700,
                          fontSize: 23),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                ),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            model.instructions[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'opensans',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );

          //     ListTile(
          //   leading: Text(
          //     '${index + 1}',
          //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          //   ),
          //   title: Text(
          //     model.instructions[index],
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontFamily: 'opensans',
          //     ),
          //   ),
          // );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: model.instructions.length,
      );
    }
  }
}
