import '../../domain/models/friend_profile.dart';
import '../../domain/models/shared_card.dart';
import '../../domain/repositories/social_repository.dart';
import '../datasources/friend_api.dart';
import '../datasources/share_api.dart';

class SocialRepositoryImpl implements SocialRepository {
  final ShareApi _shareApi;
  final FriendApi _friendApi;

  SocialRepositoryImpl(this._shareApi, this._friendApi);

  @override
  Future<SharedCard> generateCard({
    required String cardType,
    required Map<String, dynamic> sourceData,
  }) {
    return _shareApi.generateCard(
      cardType: cardType,
      sourceData: sourceData,
    );
  }

  @override
  Future<SharedCard> getCardByToken(String token) {
    return _shareApi.getCardByToken(token);
  }

  @override
  Future<List<SharedCard>> listMyCards({String? cardType, int limit = 20}) {
    return _shareApi.listMyCards(cardType: cardType, limit: limit);
  }

  @override
  Future<FriendProfile> createFriend({
    required String name,
    required String birthDate,
    String? birthTime,
    required double latitude,
    required double longitude,
    required String timezone,
    String? birthLocationName,
    String? relationshipLabel,
  }) {
    return _friendApi.createFriend(
      name: name,
      birthDate: birthDate,
      birthTime: birthTime,
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
      birthLocationName: birthLocationName,
      relationshipLabel: relationshipLabel,
    );
  }

  @override
  Future<List<FriendProfile>> listFriends({int limit = 50}) {
    return _friendApi.listFriends(limit: limit);
  }

  @override
  Future<FriendProfile> getFriend(String id) {
    return _friendApi.getFriend(id);
  }

  @override
  Future<FriendProfile> updateFriend(
    String id,
    Map<String, dynamic> updates,
  ) {
    return _friendApi.updateFriend(id, updates);
  }

  @override
  Future<void> deleteFriend(String id) {
    return _friendApi.deleteFriend(id);
  }
}
