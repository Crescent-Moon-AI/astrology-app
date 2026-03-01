import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';

enum AppLocaleMode { zh, en, system }

class LocaleNotifier extends Notifier<AppLocaleMode> {
  static const _key = 'app_locale_mode';

  @override
  AppLocaleMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final value = prefs.getString(_key);
    return AppLocaleMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppLocaleMode.system,
    );
  }

  void setMode(AppLocaleMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }
}

final localeModeProvider = NotifierProvider<LocaleNotifier, AppLocaleMode>(
  LocaleNotifier.new,
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
