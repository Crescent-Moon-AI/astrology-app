import 'package:flutter/material.dart';

class CosmicColors {
  CosmicColors._();

  static const background = Color(0xFF0A0A14);
  static const surface = Color(0x0DFFFFFF); // 5% white
  static const surfaceElevated = Color(0x14FFFFFF); // 8% white
  static const surfaceHighlight = Color(0x1FFFFFFF); // 12% white
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);
  static const secondary = Color(0xFFFDCB6E);
  static const secondaryLight = Color(0xFFFFEAA7);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0x99FFFFFF); // 60%
  static const textTertiary = Color(0x61FFFFFF); // 38%
  static const borderGlow = Color(0x4D6C5CE7); // 30%
  static const divider = Color(0x14FFFFFF); // 8%
  static const error = Color(0xFFFF6B6B);
  static const success = Color(0xFF51CF66);
  static const warning = Color(0xFFFCC419);

  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
