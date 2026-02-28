import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/friend_api.dart';
import '../../data/datasources/share_api.dart';
import '../../data/repositories/social_repository_impl.dart';
import '../../domain/models/friend_profile.dart';
import '../../domain/models/shared_card.dart';
import '../../domain/repositories/social_repository.dart';

// API data sources
final shareApiProvider = Provider<ShareApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ShareApi(dioClient.dio);
});

final friendApiProvider = Provider<FriendApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FriendApi(dioClient.dio);
});

// Repository
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final shareApi = ref.watch(shareApiProvider);
  final friendApi = ref.watch(friendApiProvider);
  return SocialRepositoryImpl(shareApi, friendApi);
});

// Friends list
final friendsProvider =
    FutureProvider.autoDispose<List<FriendProfile>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.listFriends();
});

// Single friend detail
final friendDetailProvider =
    FutureProvider.family<FriendProfile, String>((ref, id) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getFriend(id);
});

// My share cards
final myShareCardsProvider =
    FutureProvider.autoDispose<List<SharedCard>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.listMyCards();
});
