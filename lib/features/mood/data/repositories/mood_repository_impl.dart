import '../../domain/models/mood_entry.dart';
import '../../domain/models/mood_insight.dart';
import '../../domain/models/mood_stats.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_api.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodApi _api;

  MoodRepositoryImpl(this._api);

  @override
  Future<MoodEntry> submitMood({
    required int score,
    List<String>? tags,
    String? note,
  }) async {
    return _api.submitMood(score: score, tags: tags, note: note);
  }

  @override
  Future<List<MoodEntry>> listEntries(String from, String to) async {
    return _api.listEntries(from, to);
  }

  @override
  Future<void> deleteEntry(String id) async {
    return _api.deleteEntry(id);
  }

  @override
  Future<MoodStats> getStats(String period) async {
    return _api.getStats(period);
  }

  @override
  Future<MoodInsightsResponse> getInsights() async {
    return _api.getInsights();
  }
}
