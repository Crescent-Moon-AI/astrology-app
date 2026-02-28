import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cosmic_theme.dart';

enum AppThemeMode { cosmic, classic, system }

final themeModeProvider =
    StateProvider<AppThemeMode>((ref) => AppThemeMode.cosmic);

final themeDataProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);
  switch (mode) {
    case AppThemeMode.cosmic:
      return CosmicTheme.dark;
    case AppThemeMode.classic:
      return CosmicTheme.classic;
    case AppThemeMode.system:
      // Default to cosmic for now; can be expanded to check
      // WidgetsBinding.instance.platformDispatcher.platformBrightness later.
      return CosmicTheme.dark;
  }
});

final reducedMotionProvider = StateProvider<bool>((ref) => false);
