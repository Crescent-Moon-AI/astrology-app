import 'package:dio/dio.dart';

import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  ChatRepositoryImpl(this._dio);

  @override
  Future<List<Conversation>> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get(
      '/api/conversations',
      queryParameters: queryParams,
    );
    final data = response.data as Map<String, dynamic>;
    final items = data['conversations'] as List<dynamic>? ?? [];
    return items
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Conversation> getConversation(String id) async {
    final response = await _dio.get('/api/conversations/$id');
    final data = response.data as Map<String, dynamic>;
    return Conversation.fromJson(data);
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get(
      '/api/conversations/$conversationId/messages',
      queryParameters: queryParams,
    );
    final data = response.data as Map<String, dynamic>;
    final items = data['messages'] as List<dynamic>? ?? [];
    return items.map((e) {
      final json = e as Map<String, dynamic>;
      final role = (json['role'] as String) == 'user'
          ? MessageRole.user
          : MessageRole.assistant;
      final blockList = (json['blocks'] as List<dynamic>?)?.map((b) {
        final blockJson = b as Map<String, dynamic>;
        return MessageBlock(
          id: blockJson['id'] as String,
          idx: blockJson['idx'] as int? ?? 0,
          kind: _parseBlockKind(blockJson['kind'] as String?),
          status: _parseBlockStatus(blockJson['status'] as String?),
          contentText: blockJson['content_text'] as String?,
          payloadJson: blockJson['payload_json'] as String?,
          toolCallId: blockJson['tool_call_id'] as String?,
          toolName: blockJson['tool_name'] as String?,
          error: blockJson['error'] as String?,
          durationMs: blockJson['duration_ms'] as int?,
          metadata: blockJson['metadata'] != null
              ? BlockMetadata.fromJson(
                  blockJson['metadata'] as Map<String, dynamic>)
              : null,
        );
      }).toList();

      return ChatMessage(
        id: json['id'] as String,
        role: role,
        content: json['content'] as String?,
        blocks: blockList,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
    }).toList();
  }

  @override
  Future<String> getWsTicket() async {
    final response = await _dio.post('/api/auth/ws-ticket');
    final data = response.data as Map<String, dynamic>;
    return data['ticket'] as String;
  }

  BlockKind _parseBlockKind(String? kind) {
    switch (kind) {
      case 'text':
        return BlockKind.text;
      case 'thinking':
        return BlockKind.thinking;
      case 'tool':
        return BlockKind.tool;
      default:
        return BlockKind.text;
    }
  }

  BlockStatus? _parseBlockStatus(String? status) {
    switch (status) {
      case 'running':
        return BlockStatus.running;
      case 'success':
        return BlockStatus.success;
      case 'error':
        return BlockStatus.error;
      default:
        return null;
    }
  }
}
