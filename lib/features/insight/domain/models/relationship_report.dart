class ReportProduct {
  final String reportProductId;
  final String title;
  final String subtitle;

  const ReportProduct({
    required this.reportProductId,
    required this.title,
    required this.subtitle,
  });

  factory ReportProduct.fromJson(Map<String, dynamic> json) {
    return ReportProduct(
      reportProductId: json['report_product_id'] as String,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }
}

class ReportSection {
  final String title;
  final String content;

  const ReportSection({required this.title, required this.content});

  factory ReportSection.fromJson(Map<String, dynamic> json) {
    return ReportSection(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}

class RelationshipReport {
  final String id;
  final String userId;
  final String? friendId;
  final String reportProductId;
  final String title;
  final String subtitle;
  final String status;
  final List<ReportSection> sections;
  final DateTime generatedAt;
  final DateTime createdAt;

  const RelationshipReport({
    required this.id,
    required this.userId,
    this.friendId,
    required this.reportProductId,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.sections,
    required this.generatedAt,
    required this.createdAt,
  });

  factory RelationshipReport.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? [];
    return RelationshipReport(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      friendId: json['friend_id'] as String?,
      reportProductId: json['report_product_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      status: json['status'] as String? ?? 'done',
      sections: rawSections
          .map((e) => ReportSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt:
          DateTime.tryParse(json['generated_at'] as String? ?? '') ??
          DateTime.now(),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
