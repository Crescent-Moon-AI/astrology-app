import 'package:dio/dio.dart';
import '../../domain/models/shared_card.dart';

class ShareApi {
  final Dio _dio;

  ShareApi(this._dio);

  Future<SharedCard> generateCard({
    required String cardType,
    required Map<String, dynamic> sourceData,
  }) async {
    final response = await _dio.post(
      '/api/share/cards',
      data: {
        'card_type': cardType,
        'source_data': sourceData,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return SharedCard.fromJson(data);
  }

  Future<SharedCard> getCardByToken(String token) async {
    final response = await _dio.get('/api/share/cards/$token');
    final data = response.data['data'] as Map<String, dynamic>;
    return SharedCard.fromJson(data);
  }

  Future<List<SharedCard>> listMyCards({
    String? cardType,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cardType != null) {
      queryParams['card_type'] = cardType;
    }
    final response = await _dio.get(
      '/api/share/cards',
      queryParameters: queryParams,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['cards'] as List<dynamic>? ?? [];
    return items
        .map((e) => SharedCard.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
