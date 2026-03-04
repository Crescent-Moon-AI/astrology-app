import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/fortune_api.dart';
import '../../data/repositories/fortune_repository_impl.dart';
import '../../domain/models/daily_fortune.dart';

final fortuneApiProvider = Provider<FortuneApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FortuneApi(dioClient.dio);
});

final fortuneRepositoryProvider = Provider<FortuneRepositoryImpl>((ref) {
  final api = ref.watch(fortuneApiProvider);
  return FortuneRepositoryImpl(api);
});

/// Selected date for fortune view (null = today).
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime value) => state = value;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

/// Daily fortune for the selected date.
/// Falls back to client-generated data when the backend endpoint doesn't exist (404).
final dailyFortuneProvider = FutureProvider<DailyFortune>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final repo = ref.watch(fortuneRepositoryProvider);
  try {
    return await repo.getDailyFortune(date: dateStr);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return _fallbackFortune(date, dateStr);
    }
    rethrow;
  }
});

/// Generate deterministic fallback fortune based on date.
DailyFortune _fallbackFortune(DateTime date, String dateStr) {
  const sets = [
    {
      'title': '火花闪现 行动为先',
      'advice': '主动出击，把握机遇',
      'avoid': '犹豫不决，错失良机',
      'score': 86,
      'love': 91,
      'career': 47,
      'wealth': 40,
      'study': 96,
      'color': '紫色',
      'number': 7,
      'flower': '薰衣草',
      'stone': '紫水晶',
    },
    {
      'title': '静水流深 以柔克刚',
      'advice': '沉淀自我，厚积薄发',
      'avoid': '急功近利，操之过急',
      'score': 72,
      'love': 65,
      'career': 78,
      'wealth': 82,
      'study': 60,
      'color': '蓝色',
      'number': 3,
      'flower': '百合',
      'stone': '月光石',
    },
    {
      'title': '星辰引路 顺势而为',
      'advice': '顺应自然，借力前行',
      'avoid': '逆流而上，孤注一掷',
      'score': 78,
      'love': 72,
      'career': 85,
      'wealth': 68,
      'study': 80,
      'color': '金色',
      'number': 9,
      'flower': '向日葵',
      'stone': '黄水晶',
    },
  ];
  final s = sets[date.day % sets.length];
  return DailyFortune(
    date: dateStr,
    title: s['title'] as String,
    advice: s['advice'] as String,
    avoid: s['avoid'] as String,
    moonPhase: 'waxing_crescent',
    overallScore: s['score'] as int,
    dimensions: [
      FortuneDimension(key: 'love', label: '恋爱', score: s['love'] as int),
      FortuneDimension(key: 'career', label: '事业', score: s['career'] as int),
      FortuneDimension(key: 'wealth', label: '财富', score: s['wealth'] as int),
      FortuneDimension(key: 'study', label: '学业', score: s['study'] as int),
    ],
    luckyElements: LuckyElements(
      color: s['color'] as String,
      number: s['number'] as int,
      flower: s['flower'] as String,
      stone: s['stone'] as String,
    ),
  );
}
