import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs Scoutes (basées sur les Sampana)
  static const Color voronkelyColor = Color(0xFFFFD700); // Mavo (Jaune)
  static const Color mpanazovaColor = Color(0xFF2ECC71); // Maitso (Vert)
  static const Color afoColor = Color(0xFFE74C3C); // Mena (Rouge)
  static const Color menafifyColor = Color(0xFF5B2C1F); // Grenat
  
  static const Color primaryColor = Color(0xFF1a4d7e);
  static const Color sampanaPrimaryColor = Color(0xFF1a4d7e); // Primary color for UI
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFFFA500);

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        error: errorColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: const Color(0xFF1E1E1E),
        error: errorColor,
      ),
    );
  }
}
