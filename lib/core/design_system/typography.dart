import 'package:flutter/material.dart';
import 'bordo_colors.dart';

class BordoTypography {
  static const TextStyle header = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: BordoColors.textPrimary,
    letterSpacing: -1.0,
  );

  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: BordoColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: BordoColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: BordoColors.textSecondary,
  );

  static const TextStyle inputBig = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: BordoColors.textPrimary,
  );
}
