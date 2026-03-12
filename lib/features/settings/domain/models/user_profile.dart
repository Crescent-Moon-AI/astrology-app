// Domain models for user profile / birth data.
// Matches backend ProfileResponse envelope.

enum BirthTimeAccuracy { exact, approximate, unknown }

class UserProfile {
  final UserAstrologyCore core;
  final UserBirthPlace? currentBirthPlace;
  final UserBirthPlace? currentCity;
  final List<UserBirthPlace> birthPlaces;

  const UserProfile({
    required this.core,
    this.currentBirthPlace,
    this.currentCity,
    this.birthPlaces = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final coreJson = json['core'] as Map<String, dynamic>? ?? {};
    final placesJson = json['birth_places'] as List<dynamic>? ?? [];
    final currentPlaceJson =
        json['current_birth_place'] as Map<String, dynamic>?;
    final currentCityJson = json['current_city'] as Map<String, dynamic>?;

    return UserProfile(
      core: UserAstrologyCore.fromJson(coreJson),
      currentBirthPlace: currentPlaceJson != null
          ? UserBirthPlace.fromJson(currentPlaceJson)
          : null,
      currentCity: currentCityJson != null
          ? UserBirthPlace.fromJson(currentCityJson)
          : null,
      birthPlaces: placesJson
          .map((e) => UserBirthPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UserAstrologyCore {
  final String? userId;
  final String? birthDate; // ISO 8601 date string
  final String? birthTime; // HH:MM
  final BirthTimeAccuracy birthTimeAccuracy;
  final String? currentBirthPlaceId;
  final String? currentCityPlaceId;
  final double completenessScore;

  const UserAstrologyCore({
    this.userId,
    this.birthDate,
    this.birthTime,
    this.birthTimeAccuracy = BirthTimeAccuracy.unknown,
    this.currentBirthPlaceId,
    this.currentCityPlaceId,
    this.completenessScore = 0,
  });

  factory UserAstrologyCore.fromJson(Map<String, dynamic> json) {
    return UserAstrologyCore(
      userId: json['user_id'] as String?,
      birthDate: json['birth_date'] as String?,
      birthTime: json['birth_time'] as String?,
      birthTimeAccuracy: _parseAccuracy(json['birth_time_accuracy'] as String?),
      currentBirthPlaceId: json['current_birth_place_id'] as String?,
      currentCityPlaceId: json['current_city_place_id'] as String?,
      completenessScore: (json['completeness_score'] as num?)?.toDouble() ?? 0,
    );
  }

  static BirthTimeAccuracy _parseAccuracy(String? value) {
    switch (value) {
      case 'exact':
        return BirthTimeAccuracy.exact;
      case 'approximate':
        return BirthTimeAccuracy.approximate;
      default:
        return BirthTimeAccuracy.unknown;
    }
  }
}

class UserBirthPlace {
  final String? id;
  final String? normalizedName;
  final String? countryCode;
  final String? adminArea;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final String? source;
  final double? confidence;

  const UserBirthPlace({
    this.id,
    this.normalizedName,
    this.countryCode,
    this.adminArea,
    this.latitude,
    this.longitude,
    this.timezone,
    this.source,
    this.confidence,
  });

  factory UserBirthPlace.fromJson(Map<String, dynamic> json) {
    return UserBirthPlace(
      id: json['id'] as String?,
      normalizedName: json['normalized_name'] as String?,
      countryCode: json['country_code'] as String?,
      adminArea: json['admin_area'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
      source: json['source'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }
}
