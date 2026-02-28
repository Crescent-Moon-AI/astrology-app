import '../models/tarot_session.dart';

abstract class TarotSessionRepository {
  Future<TarotSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  });

  Future<TarotSession> getSession(String sessionId);

  Future<TarotSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<int>? selectedPositions,
  });

  Future<List<TarotSession>> listSessions(String conversationId);
}
