import 'package:dio/dio.dart';

class TransitApi {
  final Dio _dio;

  TransitApi(this._dio);

  Future<Map<String, dynamic>> getActiveTransits() async {
    final response = await _dio.get('/api/transits/active');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUpcomingTransits({int days = 30}) async {
    final response = await _dio.get(
      '/api/transits/upcoming',
      queryParameters: {'days': days},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTransitDetail(String id) async {
    final response = await _dio.get('/api/transits/$id');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> dismissTransit(String id) async {
    await _dio.post('/api/transits/$id/dismiss');
  }

  Future<Map<String, dynamic>> getCalendarEvents(int year, int month) async {
    final response = await _dio.get(
      '/api/calendar/events',
      queryParameters: {'year': year, 'month': month},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
