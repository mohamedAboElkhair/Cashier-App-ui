import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/core/styling/app_fonts.dart';

class AppStyles {
  static TextStyle primaryHeadLinesStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 30,
    color: AppColore.primaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle subtitlesStyles = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColore.secondColor,
  );
  static TextStyle blackw500 = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColore.blackColor,
  );
  static TextStyle grey12MediumStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColore.greyColor,
  );
  static TextStyle black15BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColore.blackColor,
  );
  static TextStyle black18BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColore.blackColor,
  );
}
