import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/core_providers.dart';

enum AppLocaleMode { zh, en, system }

class LocaleNotifier extends StateNotifier<AppLocaleMode> {
  final SharedPreferences _prefs;
  static const _key = 'app_locale_mode';

  LocaleNotifier(this._prefs) : super(_load(_prefs));

  static AppLocaleMode _load(SharedPreferences prefs) {
    final value = prefs.getString(_key);
    return AppLocaleMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppLocaleMode.system,
    );
  }

  void setMode(AppLocaleMode mode) {
    state = mode;
    _prefs.setString(_key, mode.name);
  }
}

final localeModeProvider = StateNotifierProvider<LocaleNotifier, AppLocaleMode>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return LocaleNotifier(prefs);
  },
);

/// Resolved locale for MaterialApp.locale.
/// Returns null for system mode so Flutter uses device locale.
final appLocaleProvider = Provider<Locale?>((ref) {
  final mode = ref.watch(localeModeProvider);
  switch (mode) {
    case AppLocaleMode.zh:
      return const Locale('zh');
    case AppLocaleMode.en:
      return const Locale('en');
    case AppLocaleMode.system:
      return null;
  }
});
