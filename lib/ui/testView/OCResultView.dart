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




ThemeData qookitDeLight = ThemeData(
  /// Colors
  primaryColor: Color(0xFFFFD53F),

  fontFamily: 'kabel',

  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: Colors.amber,
    unselectedLabelColor: Colors.black,
    labelStyle: TextStyle(
        color: Colors.amber,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'opensans'),
  ),

  indicatorColor: Colors.amber, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFBE30)).copyWith(background: Color(0xFFEAEAEA)).copyWith(error: Color(0xFFBE3944)),

  /// Text
  /*textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: 'georgia_bold',
      fontSize: 32,
    ),
    headline2: TextStyle(
      fontFamily: 'georgia',
      fontSize: 24,
    ),
    headline3: TextStyle(
      fontFamily: 'georgia_bold',
      fontSize: 20,
    ),
    headline4: TextStyle(
      fontFamily: 'opensans',
      fontSize: 20,
    ),
    headline5: TextStyle(
      fontFamily: 'opensans',
      fontSize: 15,
        fontWeight: FontWeight.bold
    ),
    headline6: TextStyle(
      fontFamily: 'opensans',
      fontSize: 16,
    ),
  ),*/
);
