import 'package:flutter/material.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:qookit/app/dimensions.dart';
import 'package:qookit/models/recipe.dart';
import 'package:stacked/stacked.dart';

class MyRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const MyRecipeCard({Key? key,required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sideLength = MediaQuery.of(context).size.width / 2 - 32;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            context.router.push(PageRouteInfo(
                'PantryView.dart',
                path: '../../ui/navigationView/pantryView/pantry_view.dart',
                args: {
                    recipe: recipe,
                    key: Key('564'),
                  },
            ));

            /*ExtendedNavigator.named('nestedNav')?.push(
              NavigationViewRoutes.recipeDetailsView,
              arguments: RecipeDetailsViewArguments(
                recipe: recipe,
                key: Key('564'),
              ),
            );*/
          },
          child: Container(
            margin: EdgeInsets.all(16),
            width: sideLength,
            height: sideLength,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2019/06/cropped-GettyImages-643764514.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  // TODO: replace with actual source
                  Positioned.fill(
                      child: Container(
                    height: Dimensions.recipeCardHeight,
                    width: Dimensions.recipeCardWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )),
                  )),
                  Positioned(
                    bottom: 16,
                    left: 8,
                    child: Text(
                      'KATE + COOKIE',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.amber,
                          fontFamily: 'opensance_bold'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child:
                    Text(recipe.title, style: TextStyle(fontFamily: 'opensance')
                        // GoogleFonts.lato(
                        //   fontWeight: FontWeight.w600,
                        // ),
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
