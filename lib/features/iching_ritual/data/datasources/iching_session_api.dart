import 'package:dio/dio.dart';

import '../../domain/models/iching_session.dart';

class IChingSessionApi {
  final Dio _dio;

  IChingSessionApi(this._dio);

  Future<IChingSession> createSession({
    required String conversationId,
    String? question,
  }) async {
    final response = await _dio.post(
      '/api/iching/sessions',
      data: {
        'conversation_id': conversationId,
        if (question != null && question.isNotEmpty) 'question': question,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return IChingSession.fromJson(data);
  }

  Future<IChingSession> getSession(String sessionId) async {
    final response = await _dio.get('/api/iching/sessions/$sessionId');
    final data = response.data['data'] as Map<String, dynamic>;
    return IChingSession.fromJson(data);
  }

  Future<IChingSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<Map<String, dynamic>>? tosses,
  }) async {
    final response = await _dio.patch(
      '/api/iching/sessions/$sessionId',
      data: {'ritual_state': ritualState, if (tosses != null) 'tosses': tosses},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return IChingSession.fromJson(data);
  }

  Future<List<IChingSession>> listSessions(String conversationId) async {
    final response = await _dio.get(
      '/api/iching/sessions',
      queryParameters: {'conversation_id': conversationId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['sessions'] as List<dynamic>? ?? [];
    return items
        .map((e) => IChingSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
