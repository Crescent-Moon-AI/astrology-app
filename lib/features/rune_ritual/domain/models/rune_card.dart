class RuneDefinition {
  final int id;
  final String name;
  final String nameZh;
  final String symbol;
  final bool isReversed;
  final String meaning;
  final String meaningZh;

  const RuneDefinition({
    required this.id,
    required this.name,
    required this.nameZh,
    required this.symbol,
    this.isReversed = false,
    required this.meaning,
    required this.meaningZh,
  });

  factory RuneDefinition.fromJson(Map<String, dynamic> json) {
    return RuneDefinition(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameZh: json['name_zh'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      isReversed: json['is_reversed'] as bool? ?? false,
      meaning: json['meaning'] as String? ?? '',
      meaningZh: json['meaning_zh'] as String? ?? '',
    );
  }
}
