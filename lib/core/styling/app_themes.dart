import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/core/styling/app_fonts.dart';
import 'package:templet/core/styling/app_styles.dart';
import 'package:templet/core/styling/saamsy_colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    extensions: const [SaamsyColors.light],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColore.welletFlap,
      brightness: Brightness.light,
      primary: AppColore.welletFlap,
      secondary: AppColore.welletFlap,
      surface: AppColore.whiteColor,
    ),
    primaryColor: AppColore.primaryColor,
    scaffoldBackgroundColor: AppColore.whiteColor,
    fontFamily: AppFonts.mainFontName,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColore.whiteColor,
      foregroundColor: AppColore.welletFlap,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      titleLarge: AppStyles.primaryHeadLinesStyle,
      titleMedium: AppStyles.subtitlesStyles,
      bodyLarge: TextStyle(color: SaamsyColors.light.ink, fontSize: 16),
      bodyMedium: TextStyle(color: SaamsyColors.light.ink, fontSize: 14),
      bodySmall: TextStyle(color: AppColore.welletFlap, fontSize: 12),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: SaamsyColors.light.action,
      disabledColor: AppColore.welletFlap,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColore.whiteColor,
      hintStyle: TextStyle(color: AppColore.welletFlap),
      labelStyle: TextStyle(color: AppColore.welletFlap),
      floatingLabelStyle: TextStyle(color: AppColore.welletFlap),
      prefixIconColor: AppColore.welletFlap,
      suffixIconColor: AppColore.welletFlap,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColore.whiteColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColore.welletFlap, width: 1.5),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: const [SaamsyColors.dark],
    colorScheme: ColorScheme.fromSeed(
      seedColor: SaamsyColors.dark.action,
      brightness: Brightness.dark,
      primary: SaamsyColors.dark.action,
      secondary: SaamsyColors.dark.brand,
      surface: SaamsyColors.dark.surface,
    ),
    primaryColor: SaamsyColors.dark.action,
    scaffoldBackgroundColor: SaamsyColors.dark.ground,
    fontFamily: AppFonts.mainFontName,
    appBarTheme: AppBarTheme(
      backgroundColor: SaamsyColors.dark.ground,
      foregroundColor: SaamsyColors.dark.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 30,
        color: SaamsyColors.dark.ink,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: SaamsyColors.dark.ink2,
      ),
      // Field/content text must stay near-white in dark mode (was rendering grey).
      bodyLarge: TextStyle(color: SaamsyColors.dark.ink, fontSize: 16),
      bodyMedium: TextStyle(color: SaamsyColors.dark.ink2, fontSize: 14),
      bodySmall: TextStyle(color: SaamsyColors.dark.ink3, fontSize: 12),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: SaamsyColors.dark.action,
      disabledColor: SaamsyColors.dark.ink3,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SaamsyColors.dark.panel,
      // Typed text inherits bodyLarge (near-white); these style label/hint/affixes.
      hintStyle: TextStyle(color: SaamsyColors.dark.ink3),
      labelStyle: TextStyle(color: SaamsyColors.dark.ink2),
      floatingLabelStyle: TextStyle(color: SaamsyColors.dark.brand),
      prefixIconColor: SaamsyColors.dark.ink3,
      suffixIconColor: SaamsyColors.dark.ink3,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SaamsyColors.dark.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SaamsyColors.dark.brand, width: 1.5),
      ),
    ),
  );
}
