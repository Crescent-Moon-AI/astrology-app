import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';

// WebSocket datasource (singleton per app lifecycle)
final chatDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  final datasource = ChatRemoteDatasource();
  ref.onDispose(() => datasource.dispose());
  return datasource;
});

// Chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ChatRepositoryImpl(dioClient.dio);
});

// Conversation list
final conversationListProvider =
    FutureProvider<List<Conversation>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.listConversations();
});

// Messages state notifier (per conversation)
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier,
    List<ChatMessage>, String>(
  (ref, conversationId) {
    final datasource = ref.watch(chatDatasourceProvider);
    return ChatMessagesNotifier(datasource, conversationId);
  },
);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatRemoteDatasource _datasource;
  final String conversationId;

  // Keep a reference to the datasource for potential future use
  ChatRemoteDatasource get datasource => _datasource;

  ChatMessagesNotifier(this._datasource, this.conversationId) : super([]);

  void addUserMessage(String content) {
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: content,
      createdAt: DateTime.now(),
    );
    state = [...state, msg];
  }

  void handleBlockUpsert(Map<String, dynamic> blockData, String messageId) {
    final kind = _parseBlockKind(blockData['kind'] as String?);
    final block = MessageBlock(
      id: blockData['id'] as String,
      idx: blockData['idx'] as int? ?? 0,
      kind: kind,
      status: _parseBlockStatus(blockData['status'] as String?),
      payloadJson: blockData['payload_json'] as String?,
      toolCallId: blockData['tool_call_id'] as String?,
      toolName: blockData['tool_name'] as String?,
      error: blockData['error'] as String?,
      durationMs: blockData['duration_ms'] as int?,
    );

    state = state.map((msg) {
      if (msg.id == messageId) {
        final existing = msg.blocks.indexWhere((b) => b.id == block.id);
        final blocks = List<MessageBlock>.from(msg.blocks);
        if (existing >= 0) {
          blocks[existing] = block;
        } else {
          blocks.add(block);
        }
        return ChatMessage(
          id: msg.id,
          role: msg.role,
          content: msg.content,
          blocks: blocks,
          createdAt: msg.createdAt,
        );
      }
      return msg;
    }).toList();
  }

  void handleBlockDelta(String blockId, String delta) {
    state = state.map((msg) {
      final blockIdx = msg.blocks.indexWhere((b) => b.id == blockId);
      if (blockIdx >= 0) {
        final blocks = List<MessageBlock>.from(msg.blocks);
        blocks[blockIdx].contentText =
            (blocks[blockIdx].contentText ?? '') + delta;
        return ChatMessage(
          id: msg.id,
          role: msg.role,
          content: msg.content,
          blocks: blocks,
          createdAt: msg.createdAt,
        );
      }
      return msg;
    }).toList();
  }

  void handleBlockDone(
    String blockId,
    String content,
    Map<String, dynamic>? blockMetadata,
  ) {
    state = state.map((msg) {
      final blockIdx = msg.blocks.indexWhere((b) => b.id == blockId);
      if (blockIdx >= 0) {
        final blocks = List<MessageBlock>.from(msg.blocks);
        blocks[blockIdx].contentText = content;
        blocks[blockIdx].status = BlockStatus.success;
        if (blockMetadata != null) {
          blocks[blockIdx].metadata = BlockMetadata.fromJson(blockMetadata);
        }
        return ChatMessage(
          id: msg.id,
          role: msg.role,
          content: msg.content,
          blocks: blocks,
          createdAt: msg.createdAt,
        );
      }
      return msg;
    }).toList();
  }

  void ensureAssistantMessage(String messageId) {
    if (!state.any((m) => m.id == messageId)) {
      state = [
        ...state,
        ChatMessage(
          id: messageId,
          role: MessageRole.assistant,
          createdAt: DateTime.now(),
        ),
      ];
    }
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
