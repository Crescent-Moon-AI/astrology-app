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
    required this.imageKey,
  });

  bool get isUpright => orientation == 'upright';
  bool get isReversed => orientation == 'reversed';

  List<String> get activeKeywords =>
      isUpright ? uprightKeywords : reversedKeywords;

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
      uprightKeywords: (json['upright_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reversedKeywords: (json['reversed_keywords'] as List<dynamic>?)
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
    return ResolvedCard(
      position: json['position'] as int,
      positionLabel: json['position_label'] as String? ?? '',
      card: TarotCard.fromJson(json['card'] as Map<String, dynamic>),
    );
  }
}
