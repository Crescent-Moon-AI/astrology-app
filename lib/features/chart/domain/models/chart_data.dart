import 'planet_data.dart';
import 'aspect_data.dart';
import 'house_data.dart';
import 'asteroid_data.dart';

class ChartInfo {
  final String name;
  final String date;
  final String location;
  final double latitude;
  final double longitude;
  final double timezoneOffset;
  final double julianDay;

  const ChartInfo({
    required this.name,
    required this.date,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timezoneOffset,
    required this.julianDay,
  });

  factory ChartInfo.fromJson(Map<String, dynamic> json) {
    // Support both flat (Python golden) and nested (Rust serde) formats
    final infoJson =
        json.containsKey('info') ? json['info'] as Map<String, dynamic> : json;
    return ChartInfo(
      name: (infoJson['name'] as String?) ?? '',
      date: (infoJson['date'] as String?) ?? '',
      location: (infoJson['location'] as String?) ?? '',
      latitude: ((infoJson['latitude'] as num?) ?? 0).toDouble(),
      longitude: ((infoJson['longitude'] as num?) ?? 0).toDouble(),
      timezoneOffset: ((infoJson['timezone_offset'] as num?) ?? 0).toDouble(),
      julianDay: ((infoJson['julian_day'] as num?) ?? 0).toDouble(),
    );
  }
}

class ChartData {
  final ChartInfo info;
  final List<PlanetData> planets;
  final HouseSystemData houses;
  final List<AspectData> aspects;
  final List<AsteroidData> asteroids;
  final List<FixedStarData> fixedStars;
  final List<StarConjunctionData> starConjunctions;

  const ChartData({
    required this.info,
    required this.planets,
    required this.houses,
    required this.aspects,
    required this.asteroids,
    required this.fixedStars,
    required this.starConjunctions,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      info: ChartInfo.fromJson(json),
      planets: (json['planets'] as List<dynamic>)
          .map((e) => PlanetData.fromJson(e as Map<String, dynamic>))
          .toList(),
      houses:
          HouseSystemData.fromJson(json['houses'] as Map<String, dynamic>),
      aspects: (json['aspects'] as List<dynamic>)
          .map((e) => AspectData.fromJson(e as Map<String, dynamic>))
          .toList(),
      asteroids: (json['asteroids'] as List<dynamic>?)
              ?.map((e) => AsteroidData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      fixedStars: (json['fixed_stars'] as List<dynamic>?)
              ?.map((e) => FixedStarData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      starConjunctions: (json['star_conjunctions'] as List<dynamic>?)
              ?.map((e) =>
                  StarConjunctionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
