import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KTHEME {
  KTHEME._();
  static ThemeData lightTheme() {
    return ThemeData(
      elevatedButtonTheme: elevetedButtonTheme(),
      textTheme: GoogleFonts.montserratTextTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1074b2),
        brightness: Brightness.light,
      ),
    );
  }

  static ElevatedButtonThemeData elevetedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
        ),
      ),
    ));
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey),
      // contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 1.0),
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
        //update
        );
  }
}
