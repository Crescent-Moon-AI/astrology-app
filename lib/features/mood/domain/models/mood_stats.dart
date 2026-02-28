class MoodStats {
  final String period;
  final String fromDate;
  final String toDate;
  final int totalEntries;
  final double averageScore;
  final Map<String, int> scoreDistribution;
  final List<TagCount> topTags;
  final MoodStreak streak;
  final Map<String, double> dailyAverages;
  final MoodTrend trend;

  const MoodStats({
    required this.period,
    required this.fromDate,
    required this.toDate,
    required this.totalEntries,
    required this.averageScore,
    required this.scoreDistribution,
    required this.topTags,
    required this.streak,
    required this.dailyAverages,
    required this.trend,
  });

  factory MoodStats.fromJson(Map<String, dynamic> json) {
    final scoreDistMap = <String, int>{};
    final rawScoreDist = json['score_distribution'] as Map<String, dynamic>?;
    if (rawScoreDist != null) {
      for (final entry in rawScoreDist.entries) {
        scoreDistMap[entry.key] = (entry.value as num).toInt();
      }
    }

    final dailyAvgMap = <String, double>{};
    final rawDailyAvg = json['daily_averages'] as Map<String, dynamic>?;
    if (rawDailyAvg != null) {
      for (final entry in rawDailyAvg.entries) {
        dailyAvgMap[entry.key] = (entry.value as num).toDouble();
      }
    }

    return MoodStats(
      period: json['period'] as String? ?? '',
      fromDate: json['from_date'] as String? ?? '',
      toDate: json['to_date'] as String? ?? '',
      totalEntries: (json['total_entries'] as num?)?.toInt() ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      scoreDistribution: scoreDistMap,
      topTags: (json['top_tags'] as List<dynamic>?)
              ?.map((e) => TagCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      streak: MoodStreak.fromJson(
          json['streak'] as Map<String, dynamic>? ?? {}),
      dailyAverages: dailyAvgMap,
      trend: MoodTrend.fromJson(
          json['trend'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class TagCount {
  final String tag;
  final int count;

  const TagCount({required this.tag, required this.count});

  factory TagCount.fromJson(Map<String, dynamic> json) {
    return TagCount(
      tag: json['tag'] as String,
      count: (json['count'] as num).toInt(),
    );
  }
}

class MoodStreak {
  final int current;
  final int longest;

  const MoodStreak({required this.current, required this.longest});

  factory MoodStreak.fromJson(Map<String, dynamic> json) {
    return MoodStreak(
      current: (json['current'] as num?)?.toInt() ?? 0,
      longest: (json['longest'] as num?)?.toInt() ?? 0,
    );
  }
}

class MoodTrend {
  final String direction;
  final double delta;
  final double vsPriorAverage;

  const MoodTrend({
    required this.direction,
    required this.delta,
    required this.vsPriorAverage,
  });

  factory MoodTrend.fromJson(Map<String, dynamic> json) {
    return MoodTrend(
      direction: json['direction'] as String? ?? 'stable',
      delta: (json['delta'] as num?)?.toDouble() ?? 0.0,
      vsPriorAverage: (json['vs_prior_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
