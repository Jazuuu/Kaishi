import 'package:flutter/material.dart';
class AppTheme {
  AppTheme._();

// Palette ColorScheme 

  static const Color primary = Color(0xFFFFD1DC);
  static const Color onPrimary = Color(0xFF4A3F45);
  static const Color secondary = Color(0xFF8FA7B3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF2C2C2C);
  static const Color error = Color(0xFFE5484D);


// Typescale TextTheme
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onPrimary,
    error: error,
    onError: Colors.white,
    surface: surface,
    onSurface: onSurface,
  );

  static const TextTheme textTheme = TextTheme(
    //Heading - screen titles
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color:onSurface,
    ),
    
    //Subheading - lesson titles, section headers
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color:onSurface,
    ),

    //Body - lesson explanations, Ai responses, vocabulary
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: onSurface,
    ),

    //Label - buttons, navigation labels, tabs
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500, // medium
      color: onSurface,
    ),

    //Caption - progress text, helper text, vocabulary labels
    labelSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color:Color(0xFF6B6B6B),
    )
  );


  // App is always on Light Theme 
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      fontFamily: 'Roboto',
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF7F8),
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}