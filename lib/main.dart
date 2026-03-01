import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'config/env.dart';
import 'shared/theme/cosmic_theme.dart';
import 'config/router.dart';
import 'core/providers/core_providers.dart';
import 'shared/providers/locale_provider.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.dev);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const YuejianApp(),
    ),
  );
}

class YuejianApp extends ConsumerStatefulWidget {
  final Locale? forceLocale;
  final String? autoLoginEmail;
  final String? autoLoginPassword;

  const YuejianApp({
    super.key,
    this.forceLocale,
    this.autoLoginEmail,
    this.autoLoginPassword,
  });

  @override
  ConsumerState<YuejianApp> createState() => _YuejianAppState();
}

class _YuejianAppState extends ConsumerState<YuejianApp> {
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
      // Auto-login for dev testing
      final email = widget.autoLoginEmail;
      final password = widget.autoLoginPassword;
      if (email != null &&
          password != null &&
          ref.read(authProvider).status != AuthStatus.authenticated) {
        await notifier.login(email, password);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    // forceLocale (dev) takes priority over user preference
    final locale = widget.forceLocale ?? ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: '月见',
      debugShowCheckedModeBanner: false,
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
