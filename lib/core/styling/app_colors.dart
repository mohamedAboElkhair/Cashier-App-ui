import 'package:flutter/material.dart';

// The canonical source of colour is now `SaamsyColors`
// (lib/core/styling/saamsy_colors.dart). These constants remain only to
// keep un-migrated screens compiling — their values have been remapped
// to match the new palette, but no new call sites should be added here.
class AppColore {
  //0xff2a3b8f old calor
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF2563EB);
  static const Color secondColor = Color(0xFFFACC15);
  static const Color blackColor = Color(0xFF1A1A11);
  static const Color greyColor = Color(0xFF66675F);
  static const Color welletFlap = Color(0xFF1D4ED8);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFA3212D);
  static const Color transparent = Colors.transparent;
}
