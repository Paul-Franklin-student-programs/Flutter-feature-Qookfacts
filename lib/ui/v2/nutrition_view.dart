import 'package:flutter/material.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:share/share.dart';

class NutritionView extends StatefulWidget {
  final String ocrResults;

  NutritionView(this.ocrResults);

  @override
  State<NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
  List<String> contentData = [];
  late String ocrResults;

  @override
  void initState() {
    super.initState();

    contentData.add(widget.ocrResults);
    ocrResults = widget.ocrResults;
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
          title: Text(
            "Qookit's Nutritional Insights",
            style: qookitLight.textTheme.headline4,
          ),
          centerTitle: true,
          backgroundColor: qookitLight.primaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: Colors.black),
              onPressed: shareContent,
            ),
          ],
        ),
        body: ListView.builder(
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
      ),
    );
  }
}
