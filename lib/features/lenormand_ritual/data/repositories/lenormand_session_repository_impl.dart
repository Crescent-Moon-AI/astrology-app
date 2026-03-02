import '../../domain/models/lenormand_session.dart';
import '../../domain/repositories/lenormand_session_repository.dart';
import '../datasources/lenormand_session_api.dart';

class LenormandSessionRepositoryImpl implements LenormandSessionRepository {
  final LenormandSessionApi _api;

  LenormandSessionRepositoryImpl(this._api);

  @override
  Future<LenormandSession> createSession({
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
  Future<LenormandSession> getSession(String sessionId) async {
    return _api.getSession(sessionId);
  }

  @override
  Future<LenormandSession> updateSession(
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
  Future<List<LenormandSession>> listSessions(String conversationId) async {
    return _api.listSessions(conversationId);
  }
}
