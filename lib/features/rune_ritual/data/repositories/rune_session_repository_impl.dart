import '../../domain/models/rune_session.dart';
import '../../domain/repositories/rune_session_repository.dart';
import '../datasources/rune_session_api.dart';

class RuneSessionRepositoryImpl implements RuneSessionRepository {
  final RuneSessionApi _api;

  RuneSessionRepositoryImpl(this._api);

  @override
  Future<RuneSession> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    return _api.createSession(
      conversationId: conversationId,
      spreadType: spreadType,
      question: question,
    );
  }

  @override
  Future<RuneSession> getSession(String sessionId) async {
    return _api.getSession(sessionId);
  }

  @override
  Future<RuneSession> updateSession(
    String sessionId, {
    required String ritualState,
  }) async {
    return _api.updateSession(sessionId, ritualState: ritualState);
  }

  @override
  Future<List<RuneSession>> listSessions(String conversationId) async {
    return _api.listSessions(conversationId);
  }
}
