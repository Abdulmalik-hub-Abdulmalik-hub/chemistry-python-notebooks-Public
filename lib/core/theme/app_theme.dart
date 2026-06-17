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
      // GYARA: CardTheme -> CardThemeData
      cardTheme: CardThemeData(
        color: ThemeColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold, color: ThemeColors.textPrimaryLight),
        // ... sauran textTheme dinka ka bar su kamar yadda suke
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ThemeColors.primaryBlue, width: 2)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.primaryBlue,
        // GYARA: withOpacity -> withValues
        inactiveTrackColor: ThemeColors.primaryBlue.withValues(alpha: 0.3),
        thumbColor: ThemeColors.primaryBlue,
        overlayColor: ThemeColors.primaryBlue.withValues(alpha: 0.2),
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
      // GYARA: CardTheme -> CardThemeData
      cardTheme: CardThemeData(
        color: ThemeColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.primaryBlueLight,
        // GYARA: withOpacity -> withValues
        inactiveTrackColor: ThemeColors.primaryBlueLight.withValues(alpha: 0.3),
        thumbColor: ThemeColors.primaryBlueLight,
        overlayColor: ThemeColors.primaryBlueLight.withValues(alpha: 0.2),
      ),
      // ... sauran settings dinka na darkTheme
    );
  }
}
