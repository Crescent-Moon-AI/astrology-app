import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cosmic_theme.dart';

enum AppThemeMode { cosmic, classic, system }

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => AppThemeMode.cosmic;

  void set(AppThemeMode mode) => state = mode;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);

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

class ReducedMotionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final reducedMotionProvider =
    NotifierProvider<ReducedMotionNotifier, bool>(ReducedMotionNotifier.new);
