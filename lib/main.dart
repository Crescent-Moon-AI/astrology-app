import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'shared/theme/cosmic_theme.dart';
import 'config/router.dart';
import 'core/providers/core_providers.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

/// Default entry point — dev mode against local backend.
///
/// Run with:
///   flutter run                           (emulator / desktop)
///   flutter run -d DEVICE_ID               (real device over WiFi)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.dev, mode: AppMode.dev);

  final astroEngine = AstroEngine();
  await astroEngine.init();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        astroEngineProvider.overrideWithValue(astroEngine),
      ],
      child: const XingjianApp(),
    ),
  );
}

class XingjianApp extends ConsumerStatefulWidget {
  final String? autoLoginEmail;
  final String? autoLoginPassword;

  const XingjianApp({
    super.key,
    this.autoLoginEmail,
    this.autoLoginPassword,
  });

  @override
  ConsumerState<XingjianApp> createState() => _XingjianAppState();
}

class _XingjianAppState extends ConsumerState<XingjianApp> {
  @override
  void initState() {
    super.initState();
    // Check stored auth token on startup
    Future.microtask(() async {
      final notifier = ref.read(authProvider.notifier);
      await notifier.checkAuth();
      // Install 401 interceptor for automatic token refresh
      ref
          .read(dioClientProvider)
          .addAuthInterceptor(onUnauthorized: () => notifier.tryRefresh());
      // Auto-login (mock mode only)
      final email = widget.autoLoginEmail;
      final password = widget.autoLoginPassword;
      final auth = ref.read(authProvider);
      if (email != null &&
          password != null &&
          (auth.status != AuthStatus.authenticated || auth.user == null)) {
        await notifier.login(email, password);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(appLocaleProvider);

    // Globally disable flutter_animate when reduced-motion is enabled
    final reducedMotion = ref.watch(reducedMotionProvider);
    Animate.restartOnHotReload = true;
    if (reducedMotion) {
      Animate.defaultDuration = Duration.zero;
    } else {
      Animate.defaultDuration = const Duration(milliseconds: 300);
    }

    return MaterialApp.router(
      title: '星见',
      debugShowCheckedModeBanner: AppConfig.mode.showDebugBanner,
      theme: CosmicTheme.dark,
      darkTheme: CosmicTheme.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('zh')],
      routerConfig: router,
    );
  }
}
