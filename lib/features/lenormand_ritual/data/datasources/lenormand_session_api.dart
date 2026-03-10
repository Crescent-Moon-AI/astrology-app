import 'package:dio/dio.dart';

import '../../domain/models/lenormand_session.dart';

class LenormandSessionApi {
  final Dio _dio;

  LenormandSessionApi(this._dio);

  Future<LenormandSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    final response = await _dio.post(
      '/api/lenormand/sessions',
      data: {
        'conversation_id': conversationId,
        'spread_type': spreadType,
        if (question != null && question.isNotEmpty) 'question': question,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return LenormandSession.fromJson(data);
  }

  Future<LenormandSession> getSession(String sessionId) async {
    final response = await _dio.get('/api/lenormand/sessions/$sessionId');
    final data = response.data['data'] as Map<String, dynamic>;
    return LenormandSession.fromJson(data);
  }

  Future<LenormandSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<int>? selectedPositions,
  }) async {
    final response = await _dio.patch(
      '/api/lenormand/sessions/$sessionId',
      data: {
        'ritual_state': ritualState,
        'selected_positions': ?selectedPositions,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return LenormandSession.fromJson(data);
  }

  Future<List<LenormandSession>> listSessions(String conversationId) async {
    final response = await _dio.get(
      '/api/lenormand/sessions',
      queryParameters: {'conversation_id': conversationId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['sessions'] as List<dynamic>? ?? [];
    return items
        .map((e) => LenormandSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
