import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/diary_api.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/diary_comment.dart';

final diaryApiProvider = Provider<DiaryApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DiaryApi(dioClient.dio);
});

final diaryListProvider = FutureProvider.autoDispose<List<DiaryEntry>>((
  ref,
) async {
  return ref.watch(diaryApiProvider).list();
});

final diaryDetailProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, id) async {
      return ref.watch(diaryApiProvider).getDetail(id);
    });

final diaryCommentsProvider = FutureProvider.autoDispose
    .family<List<DiaryComment>, String>((ref, diaryId) async {
      return ref.watch(diaryApiProvider).listComments(diaryId);
    });
