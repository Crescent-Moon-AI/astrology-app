import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'core/utils/debug_observer.dart';
import 'shared/theme/cosmic_theme.dart';
import 'config/router.dart';
import 'core/providers/core_providers.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

/// Default entry point — dev mode against dev server.
///
/// Run with:
///   flutter run                                          (dev server)
///   flutter run --dart-define=API_HOST=local              (local backend via emulator)
///   flutter run --dart-define=API_HOST=lan                (local backend via LAN IP)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiHost = String.fromEnvironment('API_HOST');
  final env = switch (apiHost) {
    'local' => EnvConfig.local,
    'local-https' => EnvConfig.localHttps,
    'lan' => EnvConfig.lan,
    _ => EnvConfig.dev,
  };
  AppConfig.init(env, mode: AppMode.dev);

  final astroEngine = AstroEngine();
  await astroEngine.init();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: [if (AppConfig.mode.showStackTrace) DebugProviderObserver()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        astroEngineProvider.overrideWithValue(astroEngine),
      ],
      child: const XingjianApp(),
    ),
  );
}

class XingjianApp extends ConsumerStatefulWidget {
  final String? autoLoginPhone;
  final String? autoLoginCode;

  const XingjianApp({super.key, this.autoLoginPhone, this.autoLoginCode});

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
      final phone = widget.autoLoginPhone;
      final code = widget.autoLoginCode;
      final auth = ref.read(authProvider);
      if (phone != null &&
          code != null &&
          (auth.status != AuthStatus.authenticated || auth.user == null)) {
        await notifier.smsVerify(phone, code);
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
