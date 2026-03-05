class AsteroidData {
  final String name;
  final String nameCn;
  final String symbol;
  final String description;
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
  final int? house;

  const AsteroidData({
    required this.name,
    required this.nameCn,
    required this.symbol,
    required this.description,
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
    this.house,
  });

  factory AsteroidData.fromJson(Map<String, dynamic> json) {
    return AsteroidData(
      name: json['name'] as String,
      nameCn: json['name_cn'] as String,
      symbol: json['symbol'] as String,
      description: json['description'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      retrograde: json['retrograde'] as bool,
      sign: json['sign'] as String,
      signCn: json['sign_cn'] as String,
      signSymbol: json['sign_symbol'] as String,
      degree: json['degree'] as int,
      minute: json['minute'] as int,
      house: json['house'] as int?,
    );
  }
}

class FixedStarData {
  final String name;
  final String nameCn;
  final String constellation;
  final String constellationCn;
  final double longitude;
  final double latitude;
  final String sign;
  final String signCn;
  final String signSymbol;
  final int degree;
  final int minute;
  final String nature;
  final String meaning;

  const FixedStarData({
    required this.name,
    required this.nameCn,
    required this.constellation,
    required this.constellationCn,
    required this.longitude,
    required this.latitude,
    required this.sign,
    required this.signCn,
    required this.signSymbol,
    required this.degree,
    required this.minute,
    required this.nature,
    required this.meaning,
  });

  factory FixedStarData.fromJson(Map<String, dynamic> json) {
    return FixedStarData(
      name: json['name'] as String,
      nameCn: json['name_cn'] as String,
      constellation: json['constellation'] as String,
      constellationCn: json['constellation_cn'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      sign: json['sign'] as String,
      signCn: json['sign_cn'] as String,
      signSymbol: json['sign_symbol'] as String,
      degree: json['degree'] as int,
      minute: json['minute'] as int,
      nature: json['nature'] as String,
      meaning: json['meaning'] as String,
    );
  }
}

class StarConjunctionData {
  final String planetName;
  final String planetNameCn;
  final String starName;
  final String starNameCn;
  final double orb;

  const StarConjunctionData({
    required this.planetName,
    required this.planetNameCn,
    required this.starName,
    required this.starNameCn,
    required this.orb,
  });

  factory StarConjunctionData.fromJson(Map<String, dynamic> json) {
    return StarConjunctionData(
      planetName: json['planet_name'] as String,
      planetNameCn: json['planet_name_cn'] as String,
      starName: json['star_name'] as String,
      starNameCn: json['star_name_cn'] as String,
      orb: (json['orb'] as num).toDouble(),
    );
  }
}
