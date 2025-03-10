import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_themes/stacked_themes.dart';

@injectable
class ThemeService {
  void setLightMode(BuildContext context) {
    getThemeManager(context).setThemeMode(ThemeMode.light);
  }

  void setDarkMode(BuildContext context) {
    getThemeManager(context).setThemeMode(ThemeMode.dark);
  }

  void toggleLightDarkMode(BuildContext context) {
    getThemeManager(context).toggleDarkLightTheme();
  }

  static Color deleteColor = Color(0xFF720000);
}

ThemeData qookitLight = ThemeData(
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

  buttonTheme: ButtonThemeData(
    // Define the default button theme
    buttonColor: Colors.amber,
    textTheme: ButtonTextTheme.primary,
    padding: EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),

  /// Text
  textTheme: TextTheme(
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
      fontWeight: FontWeight.bold
    ),
    headline5: TextStyle(
      fontFamily: 'opensans',
      fontSize: 15,
        fontWeight: FontWeight.bold,
      color: Colors.black54
    ),
    headline6: TextStyle(
      fontFamily: 'opensans',
      fontSize: 16,
    ),
    bodyText1: TextStyle(
      fontFamily: 'opensans',
      fontSize: 15,
    ),
  ),
);

TextStyle headerStyle =
    TextStyle(fontFamily: 'georgia_bold', fontSize: 32, color: Colors.black);

TextStyle subheaderStyle =
    TextStyle(fontFamily: 'opensans', fontSize: 14, color: Colors.black54);

TextStyle errorTextStyle = TextStyle(fontFamily: 'opensans', color: Colors.red);


ButtonStyle getButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.amber,
      textStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'opensans',
          fontWeight: FontWeight.bold)
  );
}

ThemeData qookitDark = ThemeData();

/*List<ThemeData> getThemes() {
  return [
    ThemeData(backgroundColor: Colors.blue, accentColor: Colors.yellow),
    ThemeData(backgroundColor: Colors.white, accentColor: Colors.green),
    ThemeData(backgroundColor: Colors.purple, accentColor: Colors.green),
    ThemeData(backgroundColor: Colors.black, accentColor: Colors.red),
    ThemeData(backgroundColor: Colors.red, accentColor: Colors.blue),
  ];
}*/
