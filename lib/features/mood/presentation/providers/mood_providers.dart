import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/mood_api.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../domain/models/mood_entry.dart';
import '../../domain/models/mood_insight.dart';
import '../../domain/models/mood_stats.dart';
import '../../domain/repositories/mood_repository.dart';

// API data source
final moodApiProvider = Provider<MoodApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MoodApi(dioClient.dio);
});

// Repository
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final api = ref.watch(moodApiProvider);
  return MoodRepositoryImpl(api);
});

// Today's mood entry
final todayMoodProvider = FutureProvider.autoDispose<MoodEntry?>((ref) async {
  final api = ref.watch(moodApiProvider);
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final entries = await api.listEntries(today, today);
  return entries.isEmpty ? null : entries.first;
});

// Stats by period (e.g. "30d", "90d")
final moodStatsProvider =
    FutureProvider.family<MoodStats, String>((ref, period) async {
  return ref.watch(moodApiProvider).getStats(period);
});

// Insights (correlations with transits)
final moodInsightsProvider =
    FutureProvider.autoDispose<MoodInsightsResponse>((ref) async {
  return ref.watch(moodApiProvider).getInsights();
});

// History by month (monthKey format: "2026-02")
final moodHistoryProvider =
    FutureProvider.family<List<MoodEntry>, String>((ref, monthKey) async {
  final from = '$monthKey-01';
  final year = int.parse(monthKey.split('-')[0]);
  final month = int.parse(monthKey.split('-')[1]);
  final lastDay = DateTime(year, month + 1, 0).day;
  final to = '$monthKey-${lastDay.toString().padLeft(2, '0')}';
  return ref.watch(moodApiProvider).listEntries(from, to);
});
