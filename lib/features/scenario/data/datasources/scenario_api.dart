import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';

class ScenarioApi {
  final Dio _dio;

  ScenarioApi(this._dio);

  Future<Map<String, dynamic>> listScenarios({
    String? categorySlug,
    int limit = 20,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
    };
    if (categorySlug != null) queryParams['category'] = categorySlug;
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get(
      ApiConstants.scenarios,
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getScenario(String id) async {
    final response = await _dio.get(ApiConstants.scenarioDetail(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listCategories() async {
    final response = await _dio.get(ApiConstants.scenarioCategories);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listHotScenarios() async {
    final response = await _dio.get(ApiConstants.scenarioHot);
    return response.data as Map<String, dynamic>;
  }
}
