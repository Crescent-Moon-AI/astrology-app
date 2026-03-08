class DiaryComment {
  final String id;
  final String diaryId;
  final String userId;
  final String content;
  final bool isAI;
  final DateTime createdAt;

  DiaryComment({
    required this.id,
    required this.diaryId,
    required this.userId,
    required this.content,
    required this.isAI,
    required this.createdAt,
  });

  factory DiaryComment.fromJson(Map<String, dynamic> json) {
    return DiaryComment(
      id: json['id'] as String,
      diaryId: json['diary_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      isAI: json['is_ai'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}
