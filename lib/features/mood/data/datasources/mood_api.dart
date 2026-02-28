import 'package:dio/dio.dart';
import '../../domain/models/mood_entry.dart';
import '../../domain/models/mood_insight.dart';
import '../../domain/models/mood_stats.dart';

class MoodApi {
  final Dio _dio;

  MoodApi(this._dio);

  Future<MoodEntry> submitMood({
    required int score,
    List<String>? tags,
    String? note,
  }) async {
    final body = <String, dynamic>{
      'score': score,
    };
    if (tags != null && tags.isNotEmpty) {
      body['tags'] = tags;
    }
    if (note != null && note.isNotEmpty) {
      body['note'] = note;
    }

    final response = await _dio.post('/api/mood', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return MoodEntry.fromJson(data);
  }

  Future<List<MoodEntry>> listEntries(String from, String to) async {
    final response = await _dio.get(
      '/api/mood',
      queryParameters: {'from': from, 'to': to},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final entries = data['entries'] as List<dynamic>? ?? [];
    return entries
        .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteEntry(String id) async {
    await _dio.delete('/api/mood/$id');
  }

  Future<MoodStats> getStats(String period) async {
    final response = await _dio.get(
      '/api/mood/stats',
      queryParameters: {'period': period},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return MoodStats.fromJson(data);
  }

  Future<MoodInsightsResponse> getInsights() async {
    final response = await _dio.get('/api/mood/insights');
    final data = response.data['data'] as Map<String, dynamic>;
    return MoodInsightsResponse.fromJson(data);
  }
}
