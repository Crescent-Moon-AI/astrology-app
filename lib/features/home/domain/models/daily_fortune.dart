class DailyFortune {
  final String date;
  final String title;
  final String description;
  final String advice;
  final String avoid;
  final String moonPhase;
  final int overallScore;
  final List<FortuneDimension> dimensions;
  final LuckyElements luckyElements;

  const DailyFortune({
    required this.date,
    required this.title,
    this.description = '',
    required this.advice,
    required this.avoid,
    required this.moonPhase,
    required this.overallScore,
    required this.dimensions,
    required this.luckyElements,
  });

  factory DailyFortune.fromJson(Map<String, dynamic> json) {
    return DailyFortune(
      date: json['date'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
      avoid: json['avoid'] as String? ?? '',
      moonPhase: json['moon_phase'] as String? ?? 'waxing_crescent',
      overallScore: json['overall_score'] as int? ?? 50,
      dimensions:
          (json['dimensions'] as List<dynamic>?)
              ?.map((e) => FortuneDimension.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      luckyElements: LuckyElements.fromJson(
        json['lucky_elements'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class FortuneDimension {
  final String key;
  final String label;
  final int score;

  const FortuneDimension({
    required this.key,
    required this.label,
    required this.score,
  });

  factory FortuneDimension.fromJson(Map<String, dynamic> json) {
    return FortuneDimension(
      key: json['key'] as String,
      label: json['label'] as String? ?? '',
      score: json['score'] as int? ?? 50,
    );
  }
}

class LuckyElements {
  final String color;
  final int number;
  final String flower;
  final String stone;

  const LuckyElements({
    required this.color,
    required this.number,
    required this.flower,
    required this.stone,
  });

  factory LuckyElements.fromJson(Map<String, dynamic> json) {
    return LuckyElements(
      color: json['color'] as String? ?? '紫色',
      number: json['number'] as int? ?? 7,
      flower: json['flower'] as String? ?? '薰衣草',
      stone: json['stone'] as String? ?? '紫水晶',
    );
  }
}

class WeekPeriod {
  final String label;
  final String description;
  final int score;

  const WeekPeriod({
    required this.label,
    required this.description,
    required this.score,
  });

  factory WeekPeriod.fromJson(Map<String, dynamic> json) {
    return WeekPeriod(
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
      score: json['score'] as int? ?? 60,
    );
  }
}

class WeeklyFortune {
  final String weekStart;
  final String weekEnd;
  final String title;
  final String description;
  final String advice;
  final String avoid;
  final int overallScore;
  final List<FortuneDimension> dimensions;
  final List<WeekPeriod> periods;
  final LuckyElements luckyElements;

  const WeeklyFortune({
    required this.weekStart,
    required this.weekEnd,
    required this.title,
    required this.description,
    required this.advice,
    required this.avoid,
    required this.overallScore,
    required this.dimensions,
    required this.periods,
    required this.luckyElements,
  });

  factory WeeklyFortune.fromJson(Map<String, dynamic> json) {
    return WeeklyFortune(
      weekStart: json['week_start'] as String? ?? '',
      weekEnd: json['week_end'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
      avoid: json['avoid'] as String? ?? '',
      overallScore: json['overall_score'] as int? ?? 60,
      dimensions: (json['dimensions'] as List<dynamic>?)
              ?.map((e) => FortuneDimension.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      periods: (json['periods'] as List<dynamic>?)
              ?.map((e) => WeekPeriod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      luckyElements: LuckyElements.fromJson(
        json['lucky_elements'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
