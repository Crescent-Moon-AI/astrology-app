import '../models/rune_session.dart';

abstract class RuneSessionRepository {
  Future<RuneSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  });

  Future<RuneSession> getSession(String sessionId);

  Future<RuneSession> updateSession(
    String sessionId, {
    required String ritualState,
  });

  Future<List<RuneSession>> listSessions(String conversationId);
}
