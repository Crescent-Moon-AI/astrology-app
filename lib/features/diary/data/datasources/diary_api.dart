import 'package:dio/dio.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/diary_comment.dart';

class DiaryApi {
  final Dio _dio;

  DiaryApi(this._dio);

  Future<DiaryEntry> create({
    required String content,
    List<String>? images,
  }) async {
    final body = <String, dynamic>{'content': content};
    if (images != null && images.isNotEmpty) {
      body['images'] = images;
    }
    final response = await _dio.post('/api/diary', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return DiaryEntry.fromJson(data);
  }

  Future<List<DiaryEntry>> list({int limit = 20, int offset = 0}) async {
    final response = await _dio.get(
      '/api/diary',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getDetail(String id) async {
    final response = await _dio.get('/api/diary/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return data;
  }

  Future<List<DiaryComment>> listComments(String diaryId) async {
    final response = await _dio.get('/api/diary/$diaryId/comments');
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => DiaryComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DiaryComment> createComment(String diaryId, String content) async {
    final response = await _dio.post(
      '/api/diary/$diaryId/comments',
      data: {'content': content},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return DiaryComment.fromJson(data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/api/diary/$id');
  }

  /// Upload an image and return its URL path.
  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/api/diary/upload', data: formData);
    final data = response.data['data'] as Map<String, dynamic>;
    return data['url'] as String;
  }
}
