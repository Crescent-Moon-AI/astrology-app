import 'package:flutter/material.dart';

import 'cosmic_colors.dart';

class CosmicTheme {
  CosmicTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CosmicColors.background,
        colorScheme: const ColorScheme.dark(
          primary: CosmicColors.primary,
          secondary: CosmicColors.secondary,
          surface: CosmicColors.background,
          error: CosmicColors.error,
          onPrimary: CosmicColors.textPrimary,
          onSecondary: CosmicColors.background,
          onSurface: CosmicColors.textPrimary,
          onError: CosmicColors.textPrimary,
        ),
        cardTheme: CardThemeData(
          color: CosmicColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                const BorderSide(color: CosmicColors.borderGlow, width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: CosmicColors.textPrimary,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(color: CosmicColors.textPrimary),
          bodyLarge: TextStyle(color: CosmicColors.textPrimary),
          bodyMedium: TextStyle(color: CosmicColors.textSecondary),
          bodySmall: TextStyle(color: CosmicColors.textTertiary),
          labelLarge: TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: CosmicColors.divider,
          thickness: 1,
        ),
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CosmicColors.primary,
            foregroundColor: CosmicColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      );

  static ThemeData get classic => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: CosmicColors.primary),
      );
}
