import '../models/lenormand_session.dart';

abstract class LenormandSessionRepository {
  Future<LenormandSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  });

  Future<LenormandSession> getSession(String sessionId);

  Future<LenormandSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<int>? selectedPositions,
  });

  Future<List<LenormandSession>> listSessions(String conversationId);
}
