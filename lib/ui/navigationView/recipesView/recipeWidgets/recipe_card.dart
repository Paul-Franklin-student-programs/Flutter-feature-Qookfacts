import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/app/dimensions.dart';
import 'package:qookit/models/recipe.dart';
import 'package:qookit/ui/navigationView/recipesView/recipeWidgets/recipe_image.dart';
import 'package:stacked/stacked.dart';

class RecipeCard extends StatelessWidget {
  // TODO: Add dimension parameters
  final Recipe recipe;
  final bool showTitle;

  const RecipeCard({Key? key,required this.recipe, this.showTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var containsImage = (recipe.sourceDetail.imageUrls.isNotEmpty);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {

            // ExtendedNavigator.named('nestedNav')?.push(
            //   NavigationViewRoutes.recipeDetailsView,
            //   arguments: RecipeDetailsViewArguments(recipe: recipe, key: Key('4651')),
            // );
          },
          child: Stack(
            children: [
              RecipeImage(
                imageUrl:
                    containsImage ? recipe.sourceDetail.imageUrls.first : '',
              ),
              Positioned(
                  bottom: 8,
                  left: 16,
                  child: Row(
                    children: [
                      Text(
                        recipe.likesCount.toString() ?? '2K',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Add recipe to favorites
                          })
                    ],
                  ))
            ],
          ),
        ),
        if (showTitle)
          Container(
            width: Dimensions.recipeCardTitleWidth,
            child: Text(recipe.title,
                textAlign: TextAlign.left,
                maxLines: 2,
                style: TextStyle(
                    fontFamily: 'opensans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14)
                //  subheaderStyle.copyWith(
                //   fontSize: 15
                // ),
                ),
          )
      ],
    );
  }
}
