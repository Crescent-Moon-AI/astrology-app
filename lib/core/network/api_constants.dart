import '../../config/env.dart';

class ApiConstants {
  static String get baseUrl => AppConfig.apiBaseUrl;
  static String get wsUrl => AppConfig.wsBaseUrl;
  static const String apiPrefix = '/api';

  // Scenario endpoints
  static const String scenarios = '$apiPrefix/scenarios';
  static const String scenarioCategories = '$apiPrefix/scenarios/categories';
  static const String scenarioHot = '$apiPrefix/scenarios/hot';
  static String scenarioDetail(String id) => '$apiPrefix/scenarios/$id';

  // Profile endpoints
  static const String profile = '$apiPrefix/users/me/profile';
  static const String profileCore = '$apiPrefix/users/me/profile/core';

  // Location endpoints
  static const String locationResolve = '$apiPrefix/locations/resolve';
}
