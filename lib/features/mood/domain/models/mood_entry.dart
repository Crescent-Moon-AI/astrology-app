class MoodEntry {
  final String id;
  final int score; // 1-5
  final List<String> tags;
  final String note;
  final String loggedDate; // YYYY-MM-DD
  final DateTime createdAt;
  final DateTime updatedAt;

  const MoodEntry({
    required this.id,
    required this.score,
    required this.tags,
    required this.note,
    required this.loggedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      score: json['score'] as int,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      note: json['note'] as String? ?? '',
      loggedDate: json['logged_date'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
