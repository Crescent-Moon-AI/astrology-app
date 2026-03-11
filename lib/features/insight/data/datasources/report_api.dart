import 'package:dio/dio.dart';

class ReportApi {
  final Dio _dio;

  ReportApi(this._dio);

  Future<Map<String, dynamic>> getProduct(String reportProductId) async {
    final response = await _dio.get('/api/report-products/$reportProductId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createReport({
    required String reportProductId,
    String? friendId,
  }) async {
    final body = <String, dynamic>{
      'report_product_id': reportProductId,
      'friend_id': ?friendId,
    };
    // LLM generation can take 60-120s — override the default 30s receiveTimeout.
    final response = await _dio.post(
      '/api/reports',
      data: body,
      options: Options(receiveTimeout: const Duration(minutes: 3)),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listReports({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/api/reports',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReport(String reportId) async {
    final response = await _dio.get('/api/reports/$reportId');
    return response.data as Map<String, dynamic>;
  }
}
