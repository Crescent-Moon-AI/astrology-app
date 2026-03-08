import 'package:dio/dio.dart';

import '../../domain/models/tarot_card.dart';
import '../../domain/models/tarot_session.dart';

class TarotSessionApi {
  final Dio _dio;

  TarotSessionApi(this._dio);

  /// Unwrap response: handle both {"data": {...}} and direct {...} formats.
  Map<String, dynamic> _unwrap(dynamic responseData) {
    final map = responseData as Map<String, dynamic>;
    if (map.containsKey('data') && map['data'] is Map<String, dynamic>) {
      return map['data'] as Map<String, dynamic>;
    }
    return map;
  }

  Future<TarotSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    // Auto-create conversation if not provided
    var convId = conversationId;
    if (convId.isEmpty) {
      final convResponse = await _dio.post(
        '/api/conversations',
        data: {'title': 'Tarot', 'language': 'zh'},
      );
      final convData = _unwrap(convResponse.data);
      convId = convData['id'] as String;
    }

    final response = await _dio.post(
      '/api/tarot/sessions',
      data: {
        'conversation_id': convId,
        'spread_type': spreadType,
        if (question != null && question.isNotEmpty) 'question': question,
      },
    );
    return TarotSession.fromJson(_unwrap(response.data));
  }

  Future<TarotSession> getSession(String sessionId) async {
    final response = await _dio.get('/api/tarot/sessions/$sessionId');
    return TarotSession.fromJson(_unwrap(response.data));
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
    return TarotSession.fromJson(_unwrap(response.data));
  }

  /// Draw a single card from the shuffled deck at the given position.
  /// Returns the resolved TarotCard with orientation.
  Future<TarotCard> drawCard(String sessionId, int position) async {
    final response = await _dio.post(
      '/api/tarot/sessions/$sessionId/draw',
      data: {'position': position},
    );
    final data = _unwrap(response.data);
    final cardJson = data['card'] as Map<String, dynamic>;
    final orientation = data['orientation'] as String?;
    if (orientation != null && !cardJson.containsKey('orientation')) {
      cardJson['orientation'] = orientation;
    }
    return TarotCard.fromJson(cardJson);
  }

  Future<List<TarotSession>> listSessions(String conversationId) async {
    final response = await _dio.get(
      '/api/tarot/sessions',
      queryParameters: {'conversation_id': conversationId},
    );
    final data = _unwrap(response.data);
    final items = data['sessions'] as List<dynamic>? ?? [];
    return items
        .map((e) => TarotSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
