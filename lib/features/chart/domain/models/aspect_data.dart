enum AspectNature {
  harmonious,
  tense,
  neutral,
  minor,
  creative;

  static AspectNature fromString(String value) {
    return AspectNature.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AspectNature.neutral,
    );
  }
}

class AspectData {
  final String planet1;
  final String planet1Cn;
  final String planet1Symbol;
  final String planet2;
  final String planet2Cn;
  final String planet2Symbol;
  final String aspectName;
  final String aspectNameCn;
  final String aspectSymbol;
  final double exactAngle;
  final double actualAngle;
  final double orb;
  final AspectNature nature;
  final bool applying;

  const AspectData({
    required this.planet1,
    required this.planet1Cn,
    required this.planet1Symbol,
    required this.planet2,
    required this.planet2Cn,
    required this.planet2Symbol,
    required this.aspectName,
    required this.aspectNameCn,
    required this.aspectSymbol,
    required this.exactAngle,
    required this.actualAngle,
    required this.orb,
    required this.nature,
    required this.applying,
  });

  factory AspectData.fromJson(Map<String, dynamic> json) {
    return AspectData(
      planet1: json['planet1'] as String,
      planet1Cn: json['planet1_cn'] as String,
      planet1Symbol: json['planet1_symbol'] as String,
      planet2: json['planet2'] as String,
      planet2Cn: json['planet2_cn'] as String,
      planet2Symbol: json['planet2_symbol'] as String,
      aspectName: json['aspect_name'] as String,
      aspectNameCn: json['aspect_name_cn'] as String,
      aspectSymbol: json['aspect_symbol'] as String,
      exactAngle: (json['exact_angle'] as num).toDouble(),
      actualAngle: (json['actual_angle'] as num).toDouble(),
      orb: (json['orb'] as num).toDouble(),
      nature: AspectNature.fromString(json['nature'] as String),
      applying: json['applying'] as bool,
    );
  }

  String get formattedOrb {
    final absOrb = orb.abs();
    final deg = absOrb.truncate();
    final min = ((absOrb - deg) * 60).round();
    return '$deg\u00B0$min\'';
  }
}
