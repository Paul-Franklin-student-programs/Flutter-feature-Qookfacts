import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/scanned_ingredients_view.dart';
import 'package:qookit/ui/v2/services/facade_service.dart';
import 'package:share/share.dart';

class RecipesView extends StatefulWidget {
  final String ocrResults;
  final String manualIngredientsList;

  RecipesView(this.ocrResults, this.manualIngredientsList);

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  List<String> contentData = [];
  bool isLoading = false;
  late String ocrResults;

  @override
  void initState() {
    super.initState();

    contentData.add(widget.ocrResults);
    ocrResults = widget.ocrResults;
  }

  Future<void> loadMoreData() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final newData = await FacadeService.loadMoreRecipes(ocrResults);

    setState(() {
      contentData.addAll(newData.split('\n'));
      isLoading = false;
    });
  }

  void shareContent() {
    final textToShare = contentData.join('\n'); // Combine the content to share.
    Share.share(textToShare);
  }

  void saveToVirtualPantry(BuildContext context, String content) async {
    List<String> ingredientsList;

    if (widget.manualIngredientsList.isNotEmpty) {
      ingredientsList = widget.manualIngredientsList.split(',');
    } else {
      String ocrResponse = await FacadeService.fetchIngredients(content);
      ingredientsList = ocrResponse.split(',');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ScannedIngredientsView(ingredients: ingredientsList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var paddingBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text("Qookit's Culinary Delights", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black54),
            onPressed: shareContent,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contentData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  contentData[index],
                  style: qookitLight.textTheme.bodyText1,
                ),
              );
            },
          ),
          if (isLoading)
            Center(
              child: Container(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 10.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
            ),
          Positioned(
            bottom: 10 + paddingBottom,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.amber,
                    onPressed: () {
                      saveToVirtualPantry(context, ocrResults);
                    },
                    child: Icon(Icons.add_shopping_cart),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add to Pantry',
                    style: qookitLight.tabBarTheme.labelStyle,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10 + paddingBottom,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.amber,
                    onPressed: loadMoreData,
                    child: Icon(Icons.add),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Load More (~10s)',
                    style: qookitLight.tabBarTheme.labelStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
