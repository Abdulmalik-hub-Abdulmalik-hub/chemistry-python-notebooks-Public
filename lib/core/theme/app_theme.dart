import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/theme_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: ThemeColors.primaryBlue,
        onPrimary: Colors.white,
        secondary: ThemeColors.secondaryGreen,
        onSecondary: Colors.white,
        surface: ThemeColors.surfaceLight,
        onSurface: ThemeColors.textPrimaryLight,
        error: ThemeColors.accentRed,
      ),
      scaffoldBackgroundColor: ThemeColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: ThemeColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ThemeColors.textPrimaryLight,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ThemeColors.textPrimaryLight,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textPrimaryLight,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textPrimaryLight,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ThemeColors.textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          color: ThemeColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: ThemeColors.textSecondaryLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ThemeColors.primaryBlue, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.primaryBlue,
        inactiveTrackColor: ThemeColors.primaryBlue.withOpacity(0.3),
        thumbColor: ThemeColors.primaryBlue,
        overlayColor: ThemeColors.primaryBlue.withOpacity(0.2),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.primaryBlueLight,
        onPrimary: Colors.black,
        secondary: ThemeColors.secondaryGreenLight,
        onSecondary: Colors.black,
        surface: ThemeColors.surfaceDark,
        onSurface: ThemeColors.textPrimaryDark,
        error: ThemeColors.accentRed,
      ),
      scaffoldBackgroundColor: ThemeColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.surfaceDark,
        foregroundColor: ThemeColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardTheme(
        color: ThemeColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ThemeColors.textPrimaryDark,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ThemeColors.textPrimaryDark,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textPrimaryDark,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textPrimaryDark,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ThemeColors.textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          color: ThemeColors.textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: ThemeColors.textSecondaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryBlueLight,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ThemeColors.primaryBlueLight, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.primaryBlueLight,
        inactiveTrackColor: ThemeColors.primaryBlueLight.withOpacity(0.3),
        thumbColor: ThemeColors.primaryBlueLight,
        overlayColor: ThemeColors.primaryBlueLight.withOpacity(0.2),
      ),
    );
  }
}
