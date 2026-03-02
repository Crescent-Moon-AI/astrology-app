class LenormandCard {
  final int id;
  final int number;
  final String name;
  final String nameZh;
  final String icon;
  final List<String> keywords;
  final List<String> keywordsZh;

  const LenormandCard({
    required this.id,
    required this.number,
    required this.name,
    required this.nameZh,
    required this.icon,
    required this.keywords,
    required this.keywordsZh,
  });

  factory LenormandCard.fromJson(Map<String, dynamic> json) {
    return LenormandCard(
      id: json['id'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameZh: json['name_zh'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      keywordsZh:
          (json['keywords_zh'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class ResolvedLenormandCard {
  final int position;
  final String positionLabel;
  final LenormandCard card;

  const ResolvedLenormandCard({
    required this.position,
    required this.positionLabel,
    required this.card,
  });

  factory ResolvedLenormandCard.fromJson(Map<String, dynamic> json) {
    return ResolvedLenormandCard(
      position: json['position'] as int? ?? 0,
      positionLabel: json['position_label'] as String? ?? '',
      card: LenormandCard.fromJson(json['card'] as Map<String, dynamic>),
    );
  }
}
