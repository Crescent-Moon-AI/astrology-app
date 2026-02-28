class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';
  static const String apiPrefix = '/api';

  // Scenario endpoints
  static const String scenarios = '$apiPrefix/scenarios';
  static const String scenarioCategories = '$apiPrefix/scenarios/categories';
  static const String scenarioHot = '$apiPrefix/scenarios/hot';
  static String scenarioDetail(String id) => '$apiPrefix/scenarios/$id';
}
