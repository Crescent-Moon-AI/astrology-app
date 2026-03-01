import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/network/dio_client.dart';
import 'core/network/mock_chat_datasource.dart';
import 'core/network/mock_interceptor.dart';
import 'core/providers/core_providers.dart';
import 'features/chat/presentation/providers/chat_providers.dart';
import 'main.dart';

/// Mock entry point — self-contained, no backend required.
///
/// Overrides:
///   - dioClientProvider  → DioClient with MockInterceptor
///   - chatDatasourceProvider → MockChatDatasource
///
/// Run with:
///   flutter run -t lib/main_mock.dart
///   flutter build apk -t lib/main_mock.dart --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.dev);
  final prefs = await SharedPreferences.getInstance();

  // Build a DioClient with the mock interceptor installed
  final mockDioClient = DioClient();
  mockDioClient.dio.interceptors.insert(0, MockInterceptor());

  final mockChatDatasource = MockChatDatasource();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dioClientProvider.overrideWithValue(mockDioClient),
        chatDatasourceProvider.overrideWithValue(mockChatDatasource),
      ],
      child: const YuejianApp(
        forceLocale: Locale('zh'),
        autoLoginEmail: 'demo@yuejian.app',
        autoLoginPassword: 'mock',
      ),
    ),
  );
}
