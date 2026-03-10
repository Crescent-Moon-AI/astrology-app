import 'package:dio/dio.dart';

class FortuneApi {
  final Dio _dio;

  FortuneApi(this._dio);

  Future<Map<String, dynamic>> getDailyFortune({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) queryParams['date'] = date;

    final response = await _dio.get(
      '/api/fortune/daily',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getWeeklyFortune({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) queryParams['date'] = date;

    final response = await _dio.get(
      '/api/fortune/weekly',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }
}
