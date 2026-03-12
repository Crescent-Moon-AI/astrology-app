import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
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

/// Daily fortune by explicit date string (for detail page date picker).
final dailyFortuneByDateProvider =
    FutureProvider.family<DailyFortune, String>((ref, dateStr) async {
  final repo = ref.watch(fortuneRepositoryProvider);

  String? birthDate;
  try {
    final profile = await ref.watch(userProfileProvider.future);
    birthDate = profile.core.birthDate;
  } catch (_) {
    birthDate = null;
  }

  try {
    return await repo.getDailyFortune(date: dateStr);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      final parts = dateStr.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      return _fallbackFortune(date, dateStr, birthDate);
    }
    rethrow;
  }
});

/// Daily fortune for the selected date.
/// Falls back to client-generated data when the backend endpoint doesn't exist (404).
final dailyFortuneProvider = FutureProvider<DailyFortune>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final repo = ref.watch(fortuneRepositoryProvider);

  String? birthDate;
  try {
    final profile = await ref.watch(userProfileProvider.future);
    birthDate = profile.core.birthDate;
  } catch (_) {
    birthDate = null;
  }

  try {
    return await repo.getDailyFortune(date: dateStr);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return _fallbackFortune(date, dateStr, birthDate);
    }
    rethrow;
  }
});

/// Weekly fortune for the week containing the selected date.
final weeklyFortuneProvider = FutureProvider.family<WeeklyFortune, DateTime>((
  ref,
  date,
) async {
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final repo = ref.watch(fortuneRepositoryProvider);

  String? birthDate;
  try {
    final profile = await ref.watch(userProfileProvider.future);
    birthDate = profile.core.birthDate;
  } catch (_) {
    birthDate = null;
  }

  try {
    return await repo.getWeeklyFortune(date: dateStr);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return _fallbackWeeklyFortune(date, birthDate);
    }
    rethrow;
  }
});

/// Returns sun sign index (0=Aries … 11=Pisces) from a birth date "YYYY-MM-DD".
/// Returns null if birth date is null or cannot be parsed.
int? _sunSignIndex(String? birthDate) {
  if (birthDate == null || birthDate.isEmpty) return null;
  try {
    final parts = birthDate.split('-');
    if (parts.length < 3) return null;
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
      return 0; // Aries
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20))
      return 1; // Taurus
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20))
      return 2; // Gemini
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22))
      return 3; // Cancer
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 4; // Leo
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22))
      return 5; // Virgo
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22))
      return 6; // Libra
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return 7; // Scorpio
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return 8; // Sagittarius
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return 9; // Capricorn
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return 10; // Aquarius
    return 11; // Pisces
  } catch (_) {
    return null;
  }
}

WeeklyFortune _fallbackWeeklyFortune(DateTime date, String? birthDate) {
  final weekday = date.weekday; // 1=Mon..7=Sun
  final monday = date.subtract(Duration(days: weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // 12 sign-specific weekly themes (index 0=Aries … 11=Pisces)
  const signSets = [
    {
      // 0 Aries
      'title': '勇往直前',
      'description':
          '本周白羊座的火元素能量格外旺盛，行动力和执行力达到高峰。火星的驱动让你敢于率先迈出第一步，无论是事业还是感情都适合主动出击。',
      'advice': '大胆行动，先发制人', 'avoid': '冲动莽撞，不顾后果',
      'score': 83,
      'love': 80,
      'career': 88,
      'wealth': 75,
      'study': 78,
      'social': 82,
      'p1': '火星能量高涨，专注于最重要的目标，排除干扰大步向前。', 's1': 85,
      'p2': '适合表达意见和展示能力，他人愿意倾听你的想法。', 's2': 82,
      'p3': '周末给自己充能，适度运动释放过剩的火元素能量。', 's3': 80,
      'color': '红色', 'number': 9, 'flower': '红玫瑰', 'stone': '红碧玉',
    },
    {
      // 1 Taurus
      'title': '稳中求进',
      'description':
          '金星守护的本周，金牛座在稳健中积累能量。物质与精神的双重满足感油然而生，适合打好基础、享受生活的美好。不必急于一时，厚积方能薄发。',
      'advice': '稳步推进，享受过程', 'avoid': '固执己见，抗拒变化',
      'score': 76,
      'love': 78,
      'career': 74,
      'wealth': 82,
      'study': 72,
      'social': 70,
      'p1': '专注于能带来实际回报的任务，量入为出，财务运势稳步上升。', 's1': 78,
      'p2': '感情方面温情流露，适合与伴侣共度美好时光或增进感情。', 's2': 76,
      'p3': '周末享受美食或大自然，让感官得到充分滋养与放松。', 's3': 78,
      'color': '绿色', 'number': 6, 'flower': '玫瑰', 'stone': '绿松石',
    },
    {
      // 2 Gemini
      'title': '灵感迸发',
      'description':
          '水星加持下的双子座思维活跃、口才出众。本周信息流通顺畅，多方沟通与交流带来意想不到的机缘。保持好奇心，让灵感自由飞翔。',
      'advice': '广泛交流，抓住灵感', 'avoid': '三心二意，难以收尾',
      'score': 80,
      'love': 75,
      'career': 82,
      'wealth': 72,
      'study': 86,
      'social': 88,
      'p1': '思维最为活跃，适合头脑风暴、写作创作和学习新知识。', 's1': 84,
      'p2': '社交机会涌现，参加活动或与旧友重联都有惊喜。', 's2': 82,
      'p3': '适当放慢脚步，整理本周的信息与灵感，留下真正有价值的。', 's3': 76,
      'color': '黄色', 'number': 5, 'flower': '向日葵', 'stone': '黄玛瑙',
    },
    {
      // 3 Cancer
      'title': '内外兼顾',
      'description':
          '月亮能量丰沛，巨蟹座的直觉与情感感知力达到顶峰。本周适合关注内心世界，同时用温柔的力量维护身边重要的关系，家庭与情感都将成为你的支撑。',
      'advice': '聆听内心，守护所爱', 'avoid': '情绪化，过度担忧',
      'score': 74,
      'love': 85,
      'career': 68,
      'wealth': 70,
      'study': 74,
      'social': 76,
      'p1': '情感敏锐，适合处理需要同理心的事务，家庭关系格外温馨。', 's1': 80,
      'p2': '直觉比逻辑更可靠，信任内心的第一感应。', 's2': 74,
      'p3': '在家充电最为适合，烹饪、整理或陪伴家人都是理想选择。', 's3': 76,
      'color': '银白', 'number': 2, 'flower': '白莲', 'stone': '月光石',
    },
    {
      // 4 Leo
      'title': '光芒闪耀',
      'description':
          '太阳守护的狮子座本周光芒四射，自信与魅力指数直线上升。他人自然被你的热情所吸引，是展示才华、推进重要事项的最佳时机。',
      'advice': '大方展示，引领风潮', 'avoid': '自我中心，忽视他人',
      'score': 84,
      'love': 86,
      'career': 85,
      'wealth': 78,
      'study': 80,
      'social': 90,
      'p1': '能量最旺，大胆表达自我，让重要的人看到你的价值。', 's1': 88,
      'p2': '创意灵感丰沛，艺术或娱乐方面均有不俗表现。', 's2': 84,
      'p3': '与人欢聚、享受生活乐趣，适当成为聚会焦点。', 's3': 86,
      'color': '金色', 'number': 1, 'flower': '向日葵', 'stone': '黄水晶',
    },
    {
      // 5 Virgo
      'title': '精益求精',
      'description':
          '水星引领下，处女座的分析力与执行力双双在线。本周细节决定成败，认真对待每一个环节，脚踏实地的付出终将换来让人满意的结果。',
      'advice': '注重细节，高效执行', 'avoid': '过度完美主义，纠结小节',
      'score': 77,
      'love': 70,
      'career': 84,
      'wealth': 76,
      'study': 88,
      'social': 68,
      'p1': '适合处理积压的细节工作，整理计划、优化流程效果显著。', 's1': 82,
      'p2': '健康运势佳，建立或坚持良好的生活习惯是本周重点。', 's2': 78,
      'p3': '适当放下对完美的执念，享受已有的成果与平静。', 's3': 72,
      'color': '深绿', 'number': 4, 'flower': '薰衣草', 'stone': '绿碧玉',
    },
    {
      // 6 Libra
      'title': '和谐共赢',
      'description':
          '金星守护的天秤座本周在人际关系中如鱼得水，外交魅力与平衡智慧让你成为团队的润滑剂。感情与合作关系都将迎来令人愉快的进展。',
      'advice': '寻求共识，优雅周旋', 'avoid': '优柔寡断，回避冲突',
      'score': 79,
      'love': 84,
      'career': 76,
      'wealth': 74,
      'study': 76,
      'social': 86,
      'p1': '人际运势极佳，推进合作谈判或维护重要关系都事半功倍。', 's1': 82,
      'p2': '美感与创造力在线，适合与设计、艺术或形象相关的工作。', 's2': 78,
      'p3': '约上重要的人共度美好时光，享受生活中的优雅与平衡。', 's3': 80,
      'color': '粉色', 'number': 7, 'flower': '玫瑰', 'stone': '粉晶',
    },
    {
      // 7 Scorpio
      'title': '洞见深处',
      'description':
          '冥王星的能量赋予天蝎座深邃的洞察力与坚韧的意志。本周适合深入挖掘问题本质，无论是调查研究还是情感深化，都将带来突破性的收获。',
      'advice': '深入探索，坚定意志', 'avoid': '多疑猜忌，控制欲过强',
      'score': 78,
      'love': 82,
      'career': 80,
      'wealth': 76,
      'study': 80,
      'social': 72,
      'p1': '洞察力极强，适合深度研究、战略规划或揭示隐藏信息。', 's1': 82,
      'p2': '感情深化期，诚实坦诚能带来彼此信任的突破。', 's2': 80,
      'p3': '独处时间有助于内心整合与蜕变，适合冥想或深度阅读。', 's3': 76,
      'color': '深红', 'number': 8, 'flower': '黑玫瑰', 'stone': '黑曜石',
    },
    {
      // 8 Sagittarius
      'title': '展翅高飞',
      'description': '木星守护的射手座本周视野开阔、热情高涨。探索新领域、学习新知识或规划一次旅行都将给你带来意想不到的惊喜和成长。',
      'advice': '开拓视野，勇于尝试', 'avoid': '好高骛远，缺乏耐心',
      'score': 82,
      'love': 78,
      'career': 80,
      'wealth': 72,
      'study': 86,
      'social': 84,
      'p1': '学习运势最佳，接触新领域或深化专业知识都事半功倍。', 's1': 86,
      'p2': '与外国或远方有关的事务进展顺利，拓展国际视野。', 's2': 80,
      'p3': '户外探索或旅行计划适合提上日程，自由的空气让你充满活力。', 's3': 84,
      'color': '紫色', 'number': 3, 'flower': '紫罗兰', 'stone': '紫水晶',
    },
    {
      // 9 Capricorn
      'title': '沉稳致远',
      'description':
          '土星引领下，摩羯座的专注力与规划能力发挥到极致。踏实耕耘、长线布局是本周的主旋律，量变终将带来质变，坚持就是最好的策略。',
      'advice': '长远规划，稳健前行', 'avoid': '过于保守，拒绝机遇',
      'score': 75,
      'love': 68,
      'career': 84,
      'wealth': 80,
      'study': 82,
      'social': 66,
      'p1': '专注于职业目标，务实的努力正在积累可观的成果。', 's1': 84,
      'p2': '财务规划值得重视，长线投资与储蓄都有良好回报。', 's2': 78,
      'p3': '适当与家人共处，在稳定的环境中恢复能量。', 's3': 72,
      'color': '黑色', 'number': 8, 'flower': '常青藤', 'stone': '黑碧玺',
    },
    {
      // 10 Aquarius
      'title': '破旧立新',
      'description':
          '天王星的闪电能量激发水瓶座的创新思维与独立精神。本周是提出颠覆性想法、与志同道合者连结的好时机，你的前瞻视角将为周围带来启发。',
      'advice': '创新突破，广结同道', 'avoid': '离经叛道，忽视现实',
      'score': 80,
      'love': 72,
      'career': 82,
      'wealth': 74,
      'study': 84,
      'social': 86,
      'p1': '创意思维最活跃，适合提出新方案、挑战旧有框架。', 's1': 84,
      'p2': '社群连结带来意想不到的资源与合作机会。', 's2': 82,
      'p3': '通过科技、艺术或社会议题找到志同道合的朋友。', 's3': 80,
      'color': '蓝色', 'number': 11, 'flower': '矢车菊', 'stone': '青金石',
    },
    {
      // 11 Pisces
      'title': '梦境成真',
      'description':
          '海王星的神秘能量让双鱼座直觉与创造力达到顶峰。本周内在世界比外在现实更为丰富，允许自己沉浸在灵感与想象之中，梦想的种子正在悄然发芽。',
      'advice': '相信直觉，滋养梦想', 'avoid': '逃避现实，沉溺幻想',
      'score': 73,
      'love': 82,
      'career': 68,
      'wealth': 66,
      'study': 76,
      'social': 78,
      'p1': '创意灵感涌现，艺术创作、音乐或写作都有出色发挥。', 's1': 78,
      'p2': '情感丰沛，与亲近之人深度交流带来心灵的滋养。', 's2': 80,
      'p3': '冥想、瑜伽或亲近水边的自然，帮助心灵得到净化。', 's3': 76,
      'color': '海蓝', 'number': 7, 'flower': '水仙花', 'stone': '海蓝宝石',
    },
  ];

  final signIdx = _sunSignIndex(birthDate);
  final s = signIdx != null
      ? signSets[signIdx]
      : signSets[monday.day % signSets.length];

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
      WeekPeriod(
        label: '周一/周二',
        description: s['p1'] as String,
        score: s['s1'] as int,
      ),
      WeekPeriod(
        label: '周三/周四',
        description: s['p2'] as String,
        score: s['s2'] as int,
      ),
      WeekPeriod(
        label: '周末',
        description: s['p3'] as String,
        score: s['s3'] as int,
      ),
    ],
    luckyElements: LuckyElements(
      color: s['color'] as String,
      number: s['number'] as int,
      flower: s['flower'] as String,
      stone: s['stone'] as String,
    ),
  );
}

/// Generate deterministic fallback fortune based on date and user's sun sign.
DailyFortune _fallbackFortune(
  DateTime date,
  String dateStr,
  String? birthDate,
) {
  // 12 sign-specific daily fortune sets (index 0=Aries … 11=Pisces)
  const signSets = [
    {
      // 0 Aries
      'title': '火花四溅',
      'description':
          '今日火星能量旺盛，白羊座的行动力爆棚。遇到任何机会都果断出手，拖延只会错失良机。速战速决，敢于第一个站出来表达想法，你的热情和直率正是今日最大的优势。',
      'advice': '果断行动，先发制人', 'avoid': '冲动行事，不顾后果',
      'score': 84, 'love': 80, 'career': 90, 'wealth': 72, 'study': 78,
      'color': '红色', 'number': 9, 'flower': '红玫瑰', 'stone': '红碧玉',
    },
    {
      // 1 Taurus
      'title': '踏实丰收',
      'description':
          '今日金星带来美好滋养，金牛座在稳健中感受富足。适合处理财务事务或享受感官之美，一顿美食、一段音乐都能让你找到内心的平衡。慢下来，好事自然会来。',
      'advice': '耐心积累，享受当下', 'avoid': '固执保守，错失变化',
      'score': 76, 'love': 80, 'career': 72, 'wealth': 84, 'study': 70,
      'color': '绿色', 'number': 6, 'flower': '玫瑰', 'stone': '绿松石',
    },
    {
      // 2 Gemini
      'title': '妙语连珠',
      'description':
          '水星为双子座带来流畅的沟通运势。今日口才与文字表达都处于最佳状态，适合发邮件、做演讲、谈判或和陌生人聊天。信息就是财富，保持好奇，随时收集灵感。',
      'advice': '积极沟通，广泛连结', 'avoid': '说话不经思考', 'score': 80,
      'love': 74, 'career': 84, 'wealth': 72, 'study': 88,
      'color': '黄色', 'number': 5, 'flower': '向日葵', 'stone': '黄玛瑙',
    },
    {
      // 3 Cancer
      'title': '柔水润心',
      'description':
          '月亮的能量今日格外贴近巨蟹座，情感直觉与感知力达到峰值。适合关注家人的需求或处理家庭事务，一个温暖的拥抱或一顿家常饭，都能让彼此的心更近。',
      'advice': '关爱家人，倾听内心', 'avoid': '情绪化，杞人忧天',
      'score': 74, 'love': 86, 'career': 66, 'wealth': 68, 'study': 72,
      'color': '银白', 'number': 2, 'flower': '白莲', 'stone': '月光石',
    },
    {
      // 4 Leo
      'title': '王者归来',
      'description':
          '太阳能量今日为狮子座注入无限自信。只要走进人群，你就是焦点。适合公开发言、接受采访、展示作品或任何需要表现力的场合。真实地闪耀，就是今日最好的风水。',
      'advice': '大方展示，热情感染他人', 'avoid': '自我中心，忽视他人',
      'score': 86, 'love': 88, 'career': 86, 'wealth': 78, 'study': 80,
      'color': '金色', 'number': 1, 'flower': '向日葵', 'stone': '黄水晶',
    },
    {
      // 5 Virgo
      'title': '细节致胜',
      'description':
          '今日处女座的分析能力和专注力发挥到极致。把注意力放在细节上，把积压的事务一件件清理掉，你会发现一种难得的满足感。健康方面同样值得关注，规律饮食是今日吉祥之举。',
      'advice': '精心安排，注重细节', 'avoid': '吹毛求疵，过度焦虑',
      'score': 77, 'love': 68, 'career': 86, 'wealth': 74, 'study': 88,
      'color': '深绿', 'number': 4, 'flower': '薰衣草', 'stone': '绿碧玉',
    },
    {
      // 6 Libra
      'title': '和风拂面',
      'description':
          '金星守护，天秤座今日人缘极佳，左右逢源。无论是商务合作还是私人感情，都适合今日推进。你的平衡感与外交魅力让你在各种场合如鱼得水，顺水推舟，好事自来。',
      'advice': '展现魅力，寻求共赢', 'avoid': '优柔寡断，左右摇摆',
      'score': 80, 'love': 85, 'career': 78, 'wealth': 74, 'study': 76,
      'color': '粉色', 'number': 7, 'flower': '玫瑰', 'stone': '粉晶',
    },
    {
      // 7 Scorpio
      'title': '深潜内核',
      'description':
          '冥王星的洞察力今日格外锋利，天蝎座能看穿表象直达本质。任何调研、谈判或需要揭示真相的场合都是你的舞台。情感上，真诚坦露能化解潜在的隔阂。',
      'advice': '深入洞察，信任直觉', 'avoid': '疑神疑鬼，执念太深',
      'score': 79, 'love': 82, 'career': 80, 'wealth': 76, 'study': 78,
      'color': '深红', 'number': 8, 'flower': '黑玫瑰', 'stone': '黑曜石',
    },
    {
      // 8 Sagittarius
      'title': '箭指远方',
      'description':
          '木星今日为射手座带来好运与扩展。适合规划旅行、接触外国文化、学习新技能，或与来自远方的人交流。开放的心胸让你看到更多可能性，幸运往往藏在意想不到的角落。',
      'advice': '开拓视野，拥抱冒险', 'avoid': '夸夸其谈，不落实处',
      'score': 82, 'love': 78, 'career': 80, 'wealth': 74, 'study': 86,
      'color': '紫色', 'number': 3, 'flower': '紫罗兰', 'stone': '紫水晶',
    },
    {
      // 9 Capricorn
      'title': '步步为营',
      'description':
          '土星今日赋予摩羯座强大的执行力与韧性。面对复杂的任务不要退缩，一步一步来，你的坚持将是最终胜出的关键。职场上的努力今日格外显眼，值得被看见。',
      'advice': '踏实耕耘，志存高远', 'avoid': '过度保守，固步自封',
      'score': 76, 'love': 68, 'career': 86, 'wealth': 80, 'study': 82,
      'color': '黑色', 'number': 8, 'flower': '常青藤', 'stone': '黑碧玺',
    },
    {
      // 10 Aquarius
      'title': '另辟蹊径',
      'description':
          '天王星今日激活水瓶座的创新灵感，那些看似"离经叛道"的想法，其实正是引领未来的种子。适合提出颠覆性方案，与同频的人碰撞出火花。你越是做自己，越能吸引对的人和机遇。',
      'advice': '创新思维，打破常规', 'avoid': '固执己见，忽视反馈',
      'score': 80, 'love': 72, 'career': 84, 'wealth': 72, 'study': 86,
      'color': '蓝色', 'number': 11, 'flower': '矢车菊', 'stone': '青金石',
    },
    {
      // 11 Pisces
      'title': '梦里寻他',
      'description':
          '海王星能量今日氤氲，双鱼座的直觉与感受力超乎寻常。某个突如其来的灵感或梦境可能藏着重要信息，记得记录下来。艺术创作、冥想与聆听音乐都是今日最佳的疗愈方式。',
      'advice': '信任直觉，滋养内心', 'avoid': '逃避现实，沉溺幻想',
      'score': 73, 'love': 82, 'career': 66, 'wealth': 66, 'study': 76,
      'color': '海蓝', 'number': 7, 'flower': '水仙花', 'stone': '海蓝宝石',
    },
  ];

  final signIdx = _sunSignIndex(birthDate);
  final s = signIdx != null
      ? signSets[signIdx]
      : signSets[date.day % signSets.length];

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
