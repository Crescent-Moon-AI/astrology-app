import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/env.dart';
import '../../core/providers/core_providers.dart';

/// SharedPreferences key for the dev server URL override.
const devServerUrlKey = 'dev_server_url';

/// Restore any saved dev-server override before runApp().
/// Returns the SharedPreferences instance for provider override.
Future<SharedPreferences> restoreDevServerOverride() async {
  final prefs = await SharedPreferences.getInstance();
  final savedUrl = prefs.getString(devServerUrlKey) ?? '';
  if (savedUrl.isNotEmpty) {
    AppConfig.updateEnv(EnvConfig.custom(savedUrl));
  }
  return prefs;
}

/// Stores the user-configured server URL (empty string = use compile-time default).
class DevServerNotifier extends Notifier<String> {
  @override
  String build() {
    if (AppConfig.mode == AppMode.release || AppConfig.mode == AppMode.test) {
      return '';
    }
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(devServerUrlKey) ?? '';
  }

  /// Apply a new server URL. Empty string resets to compile-time default.
  void setServer(String url) {
    if (AppConfig.mode == AppMode.release || AppConfig.mode == AppMode.test) {
      return;
    }
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(devServerUrlKey, url);
    if (url.isEmpty) {
      AppConfig.updateEnv(AppConfig.initial);
    } else {
      AppConfig.updateEnv(EnvConfig.custom(url));
    }
    state = url;
    ref.invalidate(dioClientProvider);
  }
}

final devServerProvider = NotifierProvider<DevServerNotifier, String>(
  DevServerNotifier.new,
);
