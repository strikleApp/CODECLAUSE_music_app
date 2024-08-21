import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: GoogleFonts.roboto().fontFamily,
  useMaterial3: true,
  primaryColor: const Color(0xFF00712D),
  // Deep Green
  hintColor: const Color(0xFFFF9100),
  // Soft Cream
  scaffoldBackgroundColor: const Color(0xFFFFFBE6),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Color(0xFF00712D),
      ),
      foregroundColor: WidgetStatePropertyAll(
        Color(0xFFFFFBE6),
      ),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF00712D), // Deep Green
    textTheme: ButtonTextTheme.primary,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFF9100), // Vibrant Orange
    foregroundColor: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    color: Color(0xFF00712D), // Deep Green
    iconTheme: IconThemeData(
      color: Color(0xFFFFFBE6),
    ), // Icons in AppBar
    titleTextStyle: TextStyle(
      color: Color(0xFFFFFBE6), // AppBar title text
      fontSize: 20,
    ),
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFF00712D),
    // Deep Green
    primaryContainer: Color(0xFFD5ED9F),
    // Light Green
    secondary: Color(0xFFFF9100),
    // Vibrant Orange
    secondaryContainer: Color(0xFFD5ED9F),
    // Soft Cream
    surface: Color(0xFFFFFBE6),
    // Soft Cream
    onPrimary: Color(0xFFFFFBE6),
    // Text color on primary
    onSecondary: Color(0xFFFFFFFF),
    // Text color on background
    onSurface: Color(0xFF000000),
    // Text color on surface
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light, // Light theme
  ).copyWith(surface: const Color(0xFFFFFBE6)),
);
