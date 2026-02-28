import 'package:dio/dio.dart';

import '../../domain/models/tarot_session.dart';

class TarotSessionApi {
  final Dio _dio;

  TarotSessionApi(this._dio);

  Future<TarotSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    final response = await _dio.post(
      '/api/tarot/sessions',
      data: {
        'conversation_id': conversationId,
        'spread_type': spreadType,
        if (question != null && question.isNotEmpty) 'question': question,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return TarotSession.fromJson(data);
  }

  Future<TarotSession> getSession(String sessionId) async {
    final response = await _dio.get('/api/tarot/sessions/$sessionId');
    final data = response.data['data'] as Map<String, dynamic>;
    return TarotSession.fromJson(data);
  }

  Future<TarotSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<int>? selectedPositions,
  }) async {
    final response = await _dio.patch(
      '/api/tarot/sessions/$sessionId',
      data: {
        'ritual_state': ritualState,
        if (selectedPositions != null) 'selected_positions': selectedPositions,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return TarotSession.fromJson(data);
  }

  Future<List<TarotSession>> listSessions(String conversationId) async {
    final response = await _dio.get(
      '/api/tarot/sessions',
      queryParameters: {'conversation_id': conversationId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['sessions'] as List<dynamic>? ?? [];
    return items
        .map((e) => TarotSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
