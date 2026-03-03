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

  // Nebula — deep purple-to-black sky tones
  static const nebulaStart = Color(0xFF1A0533);
  static const nebulaMid = Color(0xFF2D1B69);
  static const nebulaEnd = Color(0xFF0A0A14);

  // Nebula accent tones for multi-layer depth
  static const nebulaBlue = Color(0xFF0D1F3C);
  static const nebulaBlueMid = Color(0xFF152D5A);
  static const nebulaTeal = Color(0xFF0A2A2A);

  // Zodiac element colors
  static const fireSigns = Color(0xFFE74C3C);
  static const earthSigns = Color(0xFF27AE60);
  static const airSigns = Color(0xFF3498DB);
  static const waterSigns = Color(0xFF2980B9);

  // Tarot-specific
  static const tarotGold = Color(0xFFD4A940);
  static const tarotGoldLight = Color(0xFFE8C96A);
  static const tarotMystic = Color(0xFF7B2FBE);

  // Shimmer / glow
  static const shimmerBase = Color(0x00FFFFFF);
  static const shimmerHighlight = Color(0x33FFFFFF); // 20% white
  static const revealGlow = Color(0xFF6C5CE7);
  static const revealGoldGlow = Color(0xFFD4A940);

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

  static const nebulaGradient = RadialGradient(
    center: Alignment(0.3, -0.5),
    radius: 1.2,
    colors: [nebulaStart, nebulaMid, nebulaEnd],
    stops: [0.0, 0.5, 1.0],
  );

  // Secondary nebula — blue accent blob (upper-right area)
  static const nebulaBlueGradient = RadialGradient(
    center: Alignment(0.8, -0.3),
    radius: 0.7,
    colors: [nebulaBlueMid, nebulaBlue, Color(0x00000000)],
    stops: [0.0, 0.4, 1.0],
  );

  // Tertiary nebula — teal/warm accent (lower area)
  static const nebulaTealGradient = RadialGradient(
    center: Alignment(-0.4, 0.6),
    radius: 0.5,
    colors: [nebulaTeal, Color(0x00000000)],
    stops: [0.0, 1.0],
  );

  // Vignette — dark edges for depth
  static const vignetteGradient = RadialGradient(
    center: Alignment(0.0, -0.2),
    radius: 0.9,
    colors: [Color(0x00000000), Color(0xA0000000)],
    stops: [0.5, 1.0],
  );

  static const goldShimmerGradient = LinearGradient(
    colors: [shimmerBase, tarotGoldLight, shimmerBase],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}
