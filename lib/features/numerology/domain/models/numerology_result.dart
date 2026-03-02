class NumerologyResult {
  final int lifePathNumber;
  final List<int> calculationSteps;
  final String meaning;
  final String meaningZh;
  final bool isMasterNumber;

  const NumerologyResult({
    required this.lifePathNumber,
    required this.calculationSteps,
    required this.meaning,
    required this.meaningZh,
    required this.isMasterNumber,
  });

  factory NumerologyResult.fromJson(Map<String, dynamic> json) {
    return NumerologyResult(
      lifePathNumber: json['life_path_number'] as int? ?? 0,
      calculationSteps:
          (json['calculation_steps'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      meaning: json['meaning'] as String? ?? '',
      meaningZh: json['meaning_zh'] as String? ?? '',
      isMasterNumber: json['is_master_number'] as bool? ?? false,
    );
  }

  NumerologyResult copyWith({
    int? lifePathNumber,
    List<int>? calculationSteps,
    String? meaning,
    String? meaningZh,
    bool? isMasterNumber,
  }) {
    return NumerologyResult(
      lifePathNumber: lifePathNumber ?? this.lifePathNumber,
      calculationSteps: calculationSteps ?? this.calculationSteps,
      meaning: meaning ?? this.meaning,
      meaningZh: meaningZh ?? this.meaningZh,
      isMasterNumber: isMasterNumber ?? this.isMasterNumber,
    );
  }
}
