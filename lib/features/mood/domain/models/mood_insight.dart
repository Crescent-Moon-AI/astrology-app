class MoodInsightsResponse {
  final int totalEntries;
  final double overallAverage;
  final bool minimumEntriesMet;
  final List<MoodInsight> insights;
  final MoodProgress progress;

  const MoodInsightsResponse({
    required this.totalEntries,
    required this.overallAverage,
    required this.minimumEntriesMet,
    required this.insights,
    required this.progress,
  });

  factory MoodInsightsResponse.fromJson(Map<String, dynamic> json) {
    return MoodInsightsResponse(
      totalEntries: (json['total_entries'] as num?)?.toInt() ?? 0,
      overallAverage: (json['overall_average'] as num?)?.toDouble() ?? 0.0,
      minimumEntriesMet: json['minimum_entries_met'] as bool? ?? false,
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => MoodInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: MoodProgress.fromJson(
          json['progress'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MoodInsight {
  final String id;
  final String transitAspectType;
  final String transitDisplayName;
  final double avgMoodScore;
  final double delta;
  final int sampleCount;
  final double correlationStrength;
  final String strengthLabel;

  const MoodInsight({
    required this.id,
    required this.transitAspectType,
    required this.transitDisplayName,
    required this.avgMoodScore,
    required this.delta,
    required this.sampleCount,
    required this.correlationStrength,
    required this.strengthLabel,
  });

  factory MoodInsight.fromJson(Map<String, dynamic> json) {
    return MoodInsight(
      id: json['id'] as String? ?? '',
      transitAspectType: json['transit_aspect_type'] as String? ?? '',
      transitDisplayName: json['transit_display_name'] as String? ?? '',
      avgMoodScore: (json['avg_mood_score'] as num?)?.toDouble() ?? 0.0,
      delta: (json['delta'] as num?)?.toDouble() ?? 0.0,
      sampleCount: (json['sample_count'] as num?)?.toInt() ?? 0,
      correlationStrength:
          (json['correlation_strength'] as num?)?.toDouble() ?? 0.0,
      strengthLabel: json['strength_label'] as String? ?? '',
    );
  }
}

class MoodProgress {
  final int entriesLogged;
  final int entriesRequired;
  final int percentage;

  const MoodProgress({
    required this.entriesLogged,
    required this.entriesRequired,
    required this.percentage,
  });

  factory MoodProgress.fromJson(Map<String, dynamic> json) {
    return MoodProgress(
      entriesLogged: (json['entries_logged'] as num?)?.toInt() ?? 0,
      entriesRequired: (json['entries_required'] as num?)?.toInt() ?? 14,
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
    );
  }
}
