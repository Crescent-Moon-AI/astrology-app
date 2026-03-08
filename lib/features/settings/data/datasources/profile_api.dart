import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/models/location_candidate.dart';
import '../../domain/models/user_profile.dart';

class ProfileApi {
  final Dio _dio;

  ProfileApi(this._dio);

  /// GET /api/users/me/profile
  Future<UserProfile> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    final data = response.data as Map<String, dynamic>;
    return UserProfile.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// PUT /api/users/me/profile/core
  Future<void> upsertCore({
    String? birthDate,
    String? birthTime,
    String? birthTimeAccuracy,
    LocationCandidate? birthPlace,
  }) async {
    final body = <String, dynamic>{};

    if (birthDate != null) body['birth_date'] = birthDate;
    if (birthTime != null) body['birth_time'] = birthTime;
    if (birthTimeAccuracy != null) {
      body['birth_time_accuracy'] = birthTimeAccuracy;
    }

    if (birthPlace != null) {
      final placeMap = <String, dynamic>{
        'normalized_name': birthPlace.name,
        'latitude': birthPlace.latitude,
        'longitude': birthPlace.longitude,
        'timezone': birthPlace.timezone,
        'country_code': birthPlace.countryCode,
        'admin_area': birthPlace.adminArea,
        'source': 'geocoded',
        'confidence': birthPlace.confidence,
      };
      if (birthPlace.id != null) {
        placeMap['id'] = birthPlace.id;
      }
      body['birth_place'] = placeMap;
    }

    await _dio.put(ApiConstants.profileCore, data: body);
  }

  /// GET /api/locations/resolve?q=xxx
  Future<GeocodeResponse> resolveLocation(
    String query, {
    String? language,
  }) async {
    final params = <String, dynamic>{'q': query};
    if (language != null) params['language'] = language;

    final response = await _dio.get(
      ApiConstants.locationResolve,
      queryParameters: params,
    );
    final data = response.data as Map<String, dynamic>;
    return GeocodeResponse.fromJson(data['data'] as Map<String, dynamic>);
  }
}
