import '../models/friend_profile.dart';
import '../models/shared_card.dart';

abstract class SocialRepository {
  // Share card operations
  Future<SharedCard> generateCard({
    required String cardType,
    required Map<String, dynamic> sourceData,
  });
  Future<SharedCard> getCardByToken(String token);
  Future<List<SharedCard>> listMyCards({String? cardType, int limit = 20});

  // Friend operations
  Future<FriendProfile> createFriend({
    required String name,
    required String birthDate,
    String? birthTime,
    required double latitude,
    required double longitude,
    required String timezone,
    String? birthLocationName,
    String? relationshipLabel,
  });
  Future<List<FriendProfile>> listFriends({int limit = 50});
  Future<FriendProfile> getFriend(String id);
  Future<FriendProfile> updateFriend(String id, Map<String, dynamic> updates);
  Future<void> deleteFriend(String id);
}
