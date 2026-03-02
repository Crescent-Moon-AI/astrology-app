class DiceResult {
  final List<int> dice;
  final int total;
  final String meaning;
  final String meaningZh;

  const DiceResult({
    required this.dice,
    required this.total,
    required this.meaning,
    required this.meaningZh,
  });

  factory DiceResult.fromJson(Map<String, dynamic> json) {
    return DiceResult(
      dice:
          (json['dice'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      total: json['total'] as int? ?? 0,
      meaning: json['meaning'] as String? ?? '',
      meaningZh: json['meaning_zh'] as String? ?? '',
    );
  }

  DiceResult copyWith({
    List<int>? dice,
    int? total,
    String? meaning,
    String? meaningZh,
  }) {
    return DiceResult(
      dice: dice ?? this.dice,
      total: total ?? this.total,
      meaning: meaning ?? this.meaning,
      meaningZh: meaningZh ?? this.meaningZh,
    );
  }
}
