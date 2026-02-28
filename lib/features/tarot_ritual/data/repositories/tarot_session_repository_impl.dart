import '../../domain/models/tarot_session.dart';
import '../../domain/repositories/tarot_session_repository.dart';
import '../datasources/tarot_session_api.dart';

class TarotSessionRepositoryImpl implements TarotSessionRepository {
  final TarotSessionApi _api;

  TarotSessionRepositoryImpl(this._api);

  @override
  Future<TarotSession> createSession({
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
  Future<TarotSession> getSession(String sessionId) async {
    return _api.getSession(sessionId);
  }

  @override
  Future<TarotSession> updateSession(
    String sessionId, {
    required String ritualState,
    List<int>? selectedPositions,
  }) async {
    return _api.updateSession(
      sessionId,
      ritualState: ritualState,
      selectedPositions: selectedPositions,
    );
  }

  @override
  Future<List<TarotSession>> listSessions(String conversationId) async {
    return _api.listSessions(conversationId);
  }
}
