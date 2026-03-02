import '../models/iching_session.dart';

abstract class IChingSessionRepository {
  Future<IChingSession> createSession({
    required String conversationId,
    String? question,
  });

  Future<IChingSession> getSession(String sessionId);

  Future<IChingSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<Map<String, dynamic>>? tosses,
  });

  Future<List<IChingSession>> listSessions(String conversationId);
}
