class PlanetData {
  final String name;
  final String nameCn;
  final String symbol;
  final double longitude;
  final double latitude;
  final double distance;
  final double speed;
  final bool retrograde;
  final String sign;
  final String signCn;
  final String signSymbol;
  final int degree;
  final int minute;
  final int second;
  final int? house;

  const PlanetData({
    required this.name,
    required this.nameCn,
    required this.symbol,
    required this.longitude,
    required this.latitude,
    required this.distance,
    required this.speed,
    required this.retrograde,
    required this.sign,
    required this.signCn,
    required this.signSymbol,
    required this.degree,
    required this.minute,
    required this.second,
    this.house,
  });

  factory PlanetData.fromJson(Map<String, dynamic> json) {
    return PlanetData(
      name: json['name'] as String,
      nameCn: (json['name_cn'] as String?) ?? '',
      symbol: (json['symbol'] as String?) ?? '',
      longitude: (json['longitude'] as num).toDouble(),
      latitude: ((json['latitude'] as num?) ?? 0).toDouble(),
      distance: ((json['distance'] as num?) ?? 0).toDouble(),
      speed: ((json['speed'] as num?) ?? 0).toDouble(),
      retrograde: (json['retrograde'] as bool?) ?? false,
      sign: json['sign'] as String,
      signCn: (json['sign_cn'] as String?) ?? '',
      signSymbol: (json['sign_symbol'] as String?) ?? '',
      degree: (json['degree'] as int?) ?? 0,
      minute: (json['minute'] as int?) ?? 0,
      second: (json['second'] as int?) ?? 0,
      house: json['house'] as int?,
    );
  }

  String get formattedPosition => '$signSymbol $degree\u00B0$minute\'';
}
