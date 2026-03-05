class HouseCuspData {
  final int number;
  final double longitude;
  final String sign;
  final String signCn;
  final String signSymbol;
  final int degree;
  final int minute;

  const HouseCuspData({
    required this.number,
    required this.longitude,
    required this.sign,
    required this.signCn,
    required this.signSymbol,
    required this.degree,
    required this.minute,
  });

  factory HouseCuspData.fromJson(Map<String, dynamic> json) {
    return HouseCuspData(
      number: (json['house_number'] ?? json['number']) as int,
      longitude: (json['longitude'] as num).toDouble(),
      sign: json['sign'] as String,
      signCn: (json['sign_cn'] as String?) ?? '',
      signSymbol: (json['sign_symbol'] as String?) ?? '',
      degree: json['degree'] as int,
      minute: json['minute'] as int,
    );
  }

  String get formattedPosition => '$signSymbol $degree\u00B0$minute\'';
}

class AnglesData {
  final double asc;
  final double mc;
  final double dsc;
  final double ic;
  final double vertex;
  final String ascSign;
  final String ascSignCn;
  final int ascDegree;
  final int ascMinute;
  final String mcSign;
  final String mcSignCn;
  final int mcDegree;
  final int mcMinute;

  const AnglesData({
    required this.asc,
    required this.mc,
    required this.dsc,
    required this.ic,
    required this.vertex,
    required this.ascSign,
    required this.ascSignCn,
    required this.ascDegree,
    required this.ascMinute,
    required this.mcSign,
    required this.mcSignCn,
    required this.mcDegree,
    required this.mcMinute,
  });

  factory AnglesData.fromJson(Map<String, dynamic> json) {
    // Support both Rust serde (nested AngleDetail) and Python (flat) formats
    final ascVal = json['asc'];
    if (ascVal is Map) {
      // Rust serde format: each angle is a nested object
      final asc = ascVal as Map<String, dynamic>;
      final mc = json['mc'] as Map<String, dynamic>;
      final dsc = json['dsc'] as Map<String, dynamic>;
      final ic = json['ic'] as Map<String, dynamic>;
      final vertex = json['vertex'] as Map<String, dynamic>;
      return AnglesData(
        asc: (asc['longitude'] as num).toDouble(),
        mc: (mc['longitude'] as num).toDouble(),
        dsc: (dsc['longitude'] as num).toDouble(),
        ic: (ic['longitude'] as num).toDouble(),
        vertex: (vertex['longitude'] as num).toDouble(),
        ascSign: (asc['sign'] as String?) ?? '',
        ascSignCn: (asc['sign_cn'] as String?) ?? '',
        ascDegree: (asc['degree'] as int?) ?? 0,
        ascMinute: (asc['minute'] as int?) ?? 0,
        mcSign: (mc['sign'] as String?) ?? '',
        mcSignCn: (mc['sign_cn'] as String?) ?? '',
        mcDegree: (mc['degree'] as int?) ?? 0,
        mcMinute: (mc['minute'] as int?) ?? 0,
      );
    }
    // Python golden data format: flat fields
    return AnglesData(
      asc: (json['asc'] as num).toDouble(),
      mc: (json['mc'] as num).toDouble(),
      dsc: (json['dsc'] as num).toDouble(),
      ic: (json['ic'] as num).toDouble(),
      vertex: (json['vertex'] as num).toDouble(),
      ascSign: (json['asc_sign'] as String?) ?? '',
      ascSignCn: (json['asc_sign_cn'] as String?) ?? '',
      ascDegree: (json['asc_degree'] as int?) ?? 0,
      ascMinute: (json['asc_minute'] as int?) ?? 0,
      mcSign: (json['mc_sign'] as String?) ?? '',
      mcSignCn: (json['mc_sign_cn'] as String?) ?? '',
      mcDegree: (json['mc_degree'] as int?) ?? 0,
      mcMinute: (json['mc_minute'] as int?) ?? 0,
    );
  }
}

class HouseSystemData {
  final String system;
  final List<HouseCuspData> cusps;
  final AnglesData angles;

  const HouseSystemData({
    required this.system,
    required this.cusps,
    required this.angles,
  });

  factory HouseSystemData.fromJson(Map<String, dynamic> json) {
    return HouseSystemData(
      system: json['system'] as String,
      cusps: (json['cusps'] as List<dynamic>)
          .map((e) => HouseCuspData.fromJson(e as Map<String, dynamic>))
          .toList(),
      angles: AnglesData.fromJson(json['angles'] as Map<String, dynamic>),
    );
  }
}
