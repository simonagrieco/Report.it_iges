import 'package:flutter/material.dart';

class AppTheme {
  AppTheme() {
    build();
  }

  ThemeData? build() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontFamily: 'SourceSerifPro',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 25,
          fontFamily: 'IconFont',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontFamily: 'SourceSerifPro',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontFamily: 'Ubuntu',
          fontWeight: FontWeight.w200,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontFamily: 'Ubuntu',
          fontWeight: FontWeight.w200,
          color: Colors.black,
        ),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(background: const Color.fromRGBO(255, 254, 248, 1)),
    );
  }
}
