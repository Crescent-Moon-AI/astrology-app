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

/// Weekly fortune for the week containing the selected date.
final weeklyFortuneProvider = FutureProvider.family<WeeklyFortune, DateTime>((ref, date) async {
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final repo = ref.watch(fortuneRepositoryProvider);
  try {
    return await repo.getWeeklyFortune(date: dateStr);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return _fallbackWeeklyFortune(date);
    }
    rethrow;
  }
});

WeeklyFortune _fallbackWeeklyFortune(DateTime date) {
  final weekday = date.weekday; // 1=Mon..7=Sun
  final monday = date.subtract(Duration(days: weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  const sets = [
    {
      'title': '蓄势待发',
      'description': '本周整体星象平稳向好，月亮经历盈亏带来情绪的自然起伏。前半段适合整理思路、推进计划；后半段人际互动趋于活跃，是拓展连接的好时机。保持内心平静，以开放的心态迎接每一天的新可能。',
      'advice': '循序渐进，广结善缘',
      'avoid': '急于求成，情绪用事',
      'score': 74,
      'love': 72, 'career': 78, 'wealth': 70, 'study': 75, 'social': 80,
      'p1': '理性当道，适合专注工作与学习，减少社交消耗，保留精力给重要事项。', 's1': 76,
      'p2': '水星与木星形成有利相位，沟通顺畅，是谈判、合作、表达想法的好时机。', 's2': 72,
      'p3': '金星进入社交宫，适合放松心情，与亲友共度时光，或享受独处的创意时间。', 's3': 80,
      'color': '蓝色', 'number': 5, 'flower': '矢车菊', 'stone': '青金石',
    },
    {
      'title': '光芒闪耀',
      'description': '太阳与木星的吉相为本周注入充沛的活力与自信。这是一个勇于表达、主动出击的好时机。工作与社交都将收获意外的好运，只要勇敢迈出第一步，星星都会为你助力。',
      'advice': '主动出击，勇于表达',
      'avoid': '过于保守，错失机缘',
      'score': 82,
      'love': 85, 'career': 82, 'wealth': 78, 'study': 80, 'social': 88,
      'p1': '太阳光芒正盛，适合展示自我、发起项目，你的创意和热情将吸引他人目光。', 's1': 84,
      'p2': '金星软化了紧张气氛，感情方面有惊喜可期，单身者可关注身边新缘分。', 's2': 80,
      'p3': '月亮盈满，情感丰沛，适合与重要之人深度交流，也适合记录心情与创作。', 's3': 86,
      'color': '金色', 'number': 9, 'flower': '向日葵', 'stone': '黄水晶',
    },
  ];
  final s = sets[monday.day % sets.length];
  return WeeklyFortune(
    weekStart: fmt(monday),
    weekEnd: fmt(sunday),
    title: s['title'] as String,
    description: s['description'] as String,
    advice: s['advice'] as String,
    avoid: s['avoid'] as String,
    overallScore: s['score'] as int,
    dimensions: [
      FortuneDimension(key: 'love', label: '恋爱', score: s['love'] as int),
      FortuneDimension(key: 'career', label: '事业', score: s['career'] as int),
      FortuneDimension(key: 'wealth', label: '财富', score: s['wealth'] as int),
      FortuneDimension(key: 'study', label: '学业', score: s['study'] as int),
      FortuneDimension(key: 'social', label: '人际', score: s['social'] as int),
    ],
    periods: [
      WeekPeriod(label: '周一/周二', description: s['p1'] as String, score: s['s1'] as int),
      WeekPeriod(label: '周三/周四', description: s['p2'] as String, score: s['s2'] as int),
      WeekPeriod(label: '周末', description: s['p3'] as String, score: s['s3'] as int),
    ],
    luckyElements: LuckyElements(
      color: s['color'] as String,
      number: s['number'] as int,
      flower: s['flower'] as String,
      stone: s['stone'] as String,
    ),
  );
}

/// Generate deterministic fallback fortune based on date.
DailyFortune _fallbackFortune(DateTime date, String dateStr) {
  const sets = [
    {
      'title': '火花闪现 行动为先',
      'description':
          '下雨天，一周的最后，星星们似乎也安静了下来。如果前几天有些情绪的起伏或想法的碰撞，今天适合让一切慢慢沉淀。没有特别需要追赶的，也没有必须解决的。就像雨后的宁静，允许自己只是存在。整理这一周的思绪，或者干脆什么都不想，都是很好的休息。',
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
      'description':
          '今天的星象显示，内在的力量远胜于外在的喧嚣。水星与海王星的和谐相位为你带来敏锐的直觉和丰富的想象力。适合深入思考、创作或与内心对话。不必急于表达，沉默中自有答案浮现。',
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
      'description':
          '木星与金星的合相照耀着你的社交宫位，今天是拓展人脉、收获善意的好时机。微笑是最好的名片，真诚是最强的磁场。顺应直觉的指引，该说的话自然会在对的时刻出口。',
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
    description: s['description'] as String,
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
