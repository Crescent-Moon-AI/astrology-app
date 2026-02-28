import '../models/mood_entry.dart';
import '../models/mood_insight.dart';
import '../models/mood_stats.dart';

abstract class MoodRepository {
  Future<MoodEntry> submitMood({
    required int score,
    List<String>? tags,
    String? note,
  });
  Future<List<MoodEntry>> listEntries(String from, String to);
  Future<void> deleteEntry(String id);
  Future<MoodStats> getStats(String period);
  Future<MoodInsightsResponse> getInsights();
}
