import '../../domain/models/location_candidate.dart';
import '../../domain/models/user_profile.dart';
import '../datasources/profile_api.dart';

class ProfileRepositoryImpl {
  final ProfileApi _api;

  ProfileRepositoryImpl(this._api);

  Future<UserProfile> getProfile() => _api.getProfile();

  Future<void> upsertCore({
    String? birthDate,
    String? birthTime,
    String? birthTimeAccuracy,
    LocationCandidate? birthPlace,
  }) => _api.upsertCore(
    birthDate: birthDate,
    birthTime: birthTime,
    birthTimeAccuracy: birthTimeAccuracy,
    birthPlace: birthPlace,
  );

  Future<GeocodeResponse> resolveLocation(String query, {String? language}) =>
      _api.resolveLocation(query, language: language);
}
