class TarotCard {
  final int id;
  final String name;
  final String nameZH;
  final String arcana;
  final int number;
  final String? suit;
  final String orientation; // "upright" or "reversed"
  final String element;
  final List<String> uprightKeywords;
  final List<String> reversedKeywords;
  final List<String> uprightKeywordsZH;
  final List<String> reversedKeywordsZH;
  final String imageKey;

  const TarotCard({
    required this.id,
    required this.name,
    required this.nameZH,
    required this.arcana,
    required this.number,
    this.suit,
    required this.orientation,
    required this.element,
    required this.uprightKeywords,
    required this.reversedKeywords,
    required this.uprightKeywordsZH,
    required this.reversedKeywordsZH,
    required this.imageKey,
  });

  bool get isUpright => orientation == 'upright';
  bool get isReversed => orientation == 'reversed';

  List<String> get activeKeywords =>
      isUpright ? uprightKeywords : reversedKeywords;

  List<String> get activeKeywordsZH =>
      isUpright ? uprightKeywordsZH : reversedKeywordsZH;

  /// Returns locale-appropriate active keywords.
  /// Falls back to English if Chinese keywords are empty.
  List<String> localizedKeywords(bool isZh) {
    if (!isZh) return activeKeywords;
    final zh = activeKeywordsZH;
    return zh.isNotEmpty ? zh : activeKeywords;
  }

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      id: json['id'] as int,
      name: json['name'] as String,
      nameZH: json['name_zh'] as String? ?? '',
      arcana: json['arcana'] as String,
      number: json['number'] as int? ?? 0,
      suit: json['suit'] as String?,
      orientation: json['orientation'] as String? ?? 'upright',
      element: json['element'] as String? ?? '',
      uprightKeywords:
          (json['upright_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reversedKeywords:
          (json['reversed_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      uprightKeywordsZH:
          (json['upright_keywords_zh'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reversedKeywordsZH:
          (json['reversed_keywords_zh'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      imageKey: json['image_key'] as String? ?? '',
    );
  }
}

class ResolvedCard {
  final int position;
  final String positionLabel;
  final TarotCard card;

  const ResolvedCard({
    required this.position,
    required this.positionLabel,
    required this.card,
  });

  factory ResolvedCard.fromJson(Map<String, dynamic> json) {
    // Backend sends "position" as a SpreadPosition object { index, label, label_zh, meaning }
    // or as a plain int — handle both.
    final posRaw = json['position'];
    int position;
    String positionLabel;
    if (posRaw is Map<String, dynamic>) {
      position = posRaw['index'] as int? ?? 0;
      positionLabel = (posRaw['label_zh'] as String?) ??
          (posRaw['label'] as String?) ??
          '';
    } else {
      position = posRaw as int? ?? 0;
      positionLabel = json['position_label'] as String? ?? '';
    }

    // Backend sends orientation at top level; merge into card data
    final cardJson = json['card'] as Map<String, dynamic>;
    final orientation = json['orientation'] as String?;
    if (orientation != null && !cardJson.containsKey('orientation')) {
      cardJson['orientation'] = orientation;
    }

    return ResolvedCard(
      position: position,
      positionLabel: positionLabel,
      card: TarotCard.fromJson(cardJson),
    );
  }
}
