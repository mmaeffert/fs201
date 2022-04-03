import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool isDarkTheme = true;
  ThemeMode get currentTheme => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Color.fromARGB(255, 189, 171, 113),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.black)
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        fontFamily: 'Poppins',

        primaryColor: Color.fromARGB(255, 112, 112, 112),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
        scaffoldBackgroundColor: Color.fromARGB(255, 32, 32, 32),
        textTheme: TextTheme(
            bodyText1: TextStyle(color: Color.fromARGB(255, 179, 178, 185)),
            bodyText2: TextStyle(color: Color.fromARGB(255, 165, 189, 201))));
  }
}
