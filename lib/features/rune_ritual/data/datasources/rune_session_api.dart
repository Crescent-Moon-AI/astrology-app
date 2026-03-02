import 'package:dio/dio.dart';

import '../../domain/models/rune_session.dart';

class RuneSessionApi {
  final Dio _dio;

  RuneSessionApi(this._dio);

  Future<RuneSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    final response = await _dio.post(
      '/api/rune/sessions',
      data: {
        'conversation_id': conversationId,
        'spread_type': spreadType,
        if (question != null && question.isNotEmpty) 'question': question,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return RuneSession.fromJson(data);
  }

  Future<RuneSession> getSession(String sessionId) async {
    final response = await _dio.get('/api/rune/sessions/$sessionId');
    final data = response.data['data'] as Map<String, dynamic>;
    return RuneSession.fromJson(data);
  }

  Future<RuneSession> updateSession(
    String sessionId, {
    required String ritualState,
  }) async {
    final response = await _dio.patch(
      '/api/rune/sessions/$sessionId',
      data: {'ritual_state': ritualState},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return RuneSession.fromJson(data);
  }

  Future<List<RuneSession>> listSessions(String conversationId) async {
    final response = await _dio.get(
      '/api/rune/sessions',
      queryParameters: {'conversation_id': conversationId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['sessions'] as List<dynamic>? ?? [];
    return items
        .map((e) => RuneSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
