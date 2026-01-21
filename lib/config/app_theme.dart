import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs Scoutes (basées sur les Sampana)
  static const Color voronkelyColor = Color(0xFFFFD700); // Mavo (Jaune)
  static const Color mpanazovaColor = Color(0xFF2ECC71); // Maitso (Vert)
  static const Color afoColor = Color(0xFFE74C3C); // Mena (Rouge)
  static const Color menafifyColor = Color(0xFF5B2C1F); // Grenat

  static const Color primaryColor = Color(0xFF1a4d7e);
  static const Color sampanaPrimaryColor = Color(
    0xFF1a4d7e,
  ); // Primary color for UI
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFFFA500);

  static const String _poppinsFamily = 'Poppins';

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: _poppinsFamily),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: _poppinsFamily),
      bodySmall: base.bodySmall?.copyWith(fontFamily: _poppinsFamily),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: _poppinsFamily,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(fontFamily: _poppinsFamily),
      labelSmall: base.labelSmall?.copyWith(fontFamily: _poppinsFamily),
    );
  }

  static ThemeData getLightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      textTheme: _buildTextTheme(base.textTheme),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        error: errorColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: _poppinsFamily,
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: _buildTextTheme(base.textTheme),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: const Color(0xFF1E1E1E),
        error: errorColor,
      ),
    );
  }
}
