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
