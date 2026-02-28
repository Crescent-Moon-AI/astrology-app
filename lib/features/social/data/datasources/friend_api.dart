import 'package:dio/dio.dart';
import '../../domain/models/friend_profile.dart';

class FriendApi {
  final Dio _dio;

  FriendApi(this._dio);

  Future<FriendProfile> createFriend({
    required String name,
    required String birthDate,
    String? birthTime,
    required double latitude,
    required double longitude,
    required String timezone,
    String? birthLocationName,
    String? relationshipLabel,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'birth_date': birthDate,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
    };
    if (birthTime != null) body['birth_time'] = birthTime;
    if (birthLocationName != null) {
      body['birth_location_name'] = birthLocationName;
    }
    if (relationshipLabel != null) {
      body['relationship_label'] = relationshipLabel;
    }

    final response = await _dio.post('/api/friends', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return FriendProfile.fromJson(data);
  }

  Future<List<FriendProfile>> listFriends({int limit = 50}) async {
    final response = await _dio.get(
      '/api/friends',
      queryParameters: {'limit': limit},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['friends'] as List<dynamic>? ?? [];
    return items
        .map((e) => FriendProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FriendProfile> getFriend(String id) async {
    final response = await _dio.get('/api/friends/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return FriendProfile.fromJson(data);
  }

  Future<FriendProfile> updateFriend(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final response = await _dio.patch('/api/friends/$id', data: updates);
    final data = response.data['data'] as Map<String, dynamic>;
    return FriendProfile.fromJson(data);
  }

  Future<void> deleteFriend(String id) async {
    await _dio.delete('/api/friends/$id');
  }
}
