import 'package:flutter/material.dart';

class ColorHelper {
  static Color get primaryTextColor => Colors.white;
  static Color get secondTextColor => Colors.white.withOpacity(0.6);

  static Color get background => Color(0xFF202333);
  static Color get backgroundContrast => Color(0xFF282C3E);

  static Color get primaryElevatedButtonColor => Color(0xFF009567);
  static Color get dangerElevatedButtonColor =>
      Colors.red[900].withOpacity(0.7);

  static Color get iconColor => Color(0xFF00FFB0);
  static Color get iconVertColor => Colors.grey;
}

/// File name of JSON DB
const String kDbName = "agents.json";

/// Decimals of formated data size
const int kDecimalBitsFormat = 0;

/// App icon image
Image kAppIcon = Image.asset("assets/icon.png", width: 26);
