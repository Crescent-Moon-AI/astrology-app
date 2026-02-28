class ScenarioCategory {
  final String id;
  final String slug;
  final String name;
  final String icon;
  final int displayOrder;

  const ScenarioCategory({
    required this.id,
    required this.slug,
    required this.name,
    required this.icon,
    required this.displayOrder,
  });

  factory ScenarioCategory.fromJson(Map<String, dynamic> json) {
    return ScenarioCategory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }
}

class Scenario {
  final String id;
  final String slug;
  final String title;
  final String description;
  final String iconUrl;
  final ScenarioCategory? category;
  final List<String> toolBindings;
  final List<String> presetQuestions;
  final int displayOrder;

  const Scenario({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.iconUrl,
    this.category,
    required this.toolBindings,
    required this.presetQuestions,
    required this.displayOrder,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      iconUrl: json['icon_url'] as String? ?? '',
      category: json['category'] != null
          ? ScenarioCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      toolBindings: (json['tool_bindings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      presetQuestions: (json['preset_questions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }
}

class ScenarioSummary {
  final String id;
  final String slug;
  final String title;
  final String iconUrl;
  final ScenarioCategorySummary? category;

  const ScenarioSummary({
    required this.id,
    required this.slug,
    required this.title,
    required this.iconUrl,
    this.category,
  });

  factory ScenarioSummary.fromJson(Map<String, dynamic> json) {
    return ScenarioSummary(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      iconUrl: json['icon_url'] as String? ?? '',
      category: json['category'] != null
          ? ScenarioCategorySummary.fromJson(
              json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ScenarioCategorySummary {
  final String slug;
  final String name;
  final String icon;

  const ScenarioCategorySummary({
    required this.slug,
    required this.name,
    required this.icon,
  });

  factory ScenarioCategorySummary.fromJson(Map<String, dynamic> json) {
    return ScenarioCategorySummary(
      slug: json['slug'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}
