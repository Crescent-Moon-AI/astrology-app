import '../../domain/models/iching_session.dart';
import '../../domain/repositories/iching_session_repository.dart';
import '../datasources/iching_session_api.dart';

class IChingSessionRepositoryImpl implements IChingSessionRepository {
  final IChingSessionApi _api;

  IChingSessionRepositoryImpl(this._api);

  @override
  Future<IChingSession> createSession({
    required String conversationId,
    String? question,
  }) async {
    return _api.createSession(
      conversationId: conversationId,
      question: question,
    );
  }

  @override
  Future<IChingSession> getSession(String sessionId) async {
    return _api.getSession(sessionId);
  }

  @override
  Future<IChingSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<Map<String, dynamic>>? tosses,
  }) async {
    return _api.updateSession(
      sessionId,
      ritualState: ritualState,
      tosses: tosses,
    );
  }

  @override
  Future<List<IChingSession>> listSessions(String conversationId) async {
    return _api.listSessions(conversationId);
  }
}
