import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/facade_service.dart';
import 'package:share/share.dart';

import '../../services/system/remote_config_service.dart';

class RecipesView extends StatefulWidget {
  final String ocrResults;

  RecipesView(this.ocrResults);

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
    ocrResults=widget.ocrResults;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
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
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: loadMoreData,
              child: Icon(Icons.add),
            ),
            Text(
              'Load More (~10s)',
              style: qookitLight.tabBarTheme.labelStyle,
            ),
          ],
        ),
      ),
    );
  }
}
