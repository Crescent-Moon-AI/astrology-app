import 'package:flutter/material.dart';

class CosmicColors {
  CosmicColors._();

  // Backgrounds — deep void black with faintest blue tint
  static const background = Color(0xFF0A0A14);
  static const backgroundDeep = Color(0xFF080810);

  // Surfaces — semi-transparent for glass morphism layering
  static const surface = Color(0x14FFFFFF); // 8% white
  static const surfaceElevated = Color(0x1AFFFFFF); // 10% white
  static const surfaceHighlight = Color(0x26FFFFFF); // 15% white

  // Primary — purple
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);

  // Secondary — gold
  static const secondary = Color(0xFFFDCB6E);
  static const secondaryLight = Color(0xFFFFEAA7);

  // Text
  static const textPrimary = Color(0xFFF8F8FF);
  static const textSecondary = Color(0x99FFFFFF); // 60%
  static const textTertiary = Color(0x66FFFFFF); // 40%

  // Borders — very subtle, rely on surface contrast
  static const borderGlow = Color(0x1AFFFFFF); // 10% white
  static const borderSubtle = Color(0x0DFFFFFF); // 5% white

  // Divider
  static const divider = Color(0x14FFFFFF); // 8% white

  // Status
  static const error = Color(0xFFFF6B6B);
  static const success = Color(0xFF51CF66);
  static const warning = Color(0xFFFCC419);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
