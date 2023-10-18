import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qookit/services/theme/theme_service.dart';

class OCRResultView extends StatefulWidget {
  final String ocrResults;

  OCRResultView(this.ocrResults);

  @override
  State<OCRResultView> createState() => _OCRResultViewState();
}

class _OCRResultViewState extends State<OCRResultView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: qookitLight,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Qookit Insights',style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: qookitLight.primaryColor, // Set the app bar color to qookitLight's primary color
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Text(
              '${widget.ocrResults}', // Updated text
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}