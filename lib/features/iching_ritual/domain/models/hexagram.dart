class HexagramLine {
  final int position; // 1-6 from bottom
  final bool isYang;
  final bool isMoving;
  final String text;
  final String textZh;

  const HexagramLine({
    required this.position,
    required this.isYang,
    this.isMoving = false,
    this.text = '',
    this.textZh = '',
  });

  factory HexagramLine.fromJson(Map<String, dynamic> json) {
    return HexagramLine(
      position: json['position'] as int? ?? 0,
      isYang: json['is_yang'] as bool? ?? true,
      isMoving: json['is_moving'] as bool? ?? false,
      text: json['text'] as String? ?? '',
      textZh: json['text_zh'] as String? ?? '',
    );
  }
}

class Hexagram {
  final int number;
  final String name;
  final String nameZh;
  final String symbol;
  final List<HexagramLine> lines;

  const Hexagram({
    required this.number,
    required this.name,
    required this.nameZh,
    required this.symbol,
    required this.lines,
  });

  factory Hexagram.fromJson(Map<String, dynamic> json) {
    return Hexagram(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameZh: json['name_zh'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map((e) => HexagramLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMovingLines => lines.any((l) => l.isMoving);
}
