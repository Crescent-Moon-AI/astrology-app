enum MessageRole { user, assistant }

enum BlockKind { text, thinking, tool }

enum BlockStatus { running, success, error }

class SectionMeta {
  final String title;
  final int startOffset;
  final int endOffset;

  SectionMeta({
    required this.title,
    required this.startOffset,
    required this.endOffset,
  });

  factory SectionMeta.fromJson(Map<String, dynamic> json) {
    return SectionMeta(
      title: json['title'] as String,
      startOffset: json['start_offset'] as int,
      endOffset: json['end_offset'] as int,
    );
  }
}

class BlockMetadata {
  final List<SectionMeta>? sections;

  BlockMetadata({this.sections});

  factory BlockMetadata.fromJson(Map<String, dynamic> json) {
    return BlockMetadata(
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => SectionMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MessageBlock {
  final String id;
  final int idx;
  final BlockKind kind;
  BlockStatus? status;
  String? contentText;
  String? payloadJson;
  String? toolCallId;
  String? toolName;
  String? error;
  int? durationMs;
  BlockMetadata? metadata;

  MessageBlock({
    required this.id,
    required this.idx,
    required this.kind,
    this.status,
    this.contentText,
    this.payloadJson,
    this.toolCallId,
    this.toolName,
    this.error,
    this.durationMs,
    this.metadata,
  });
}

class ChatMessage {
  final String id;
  final MessageRole role;
  final String? content;
  final List<MessageBlock> blocks;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.role,
    this.content,
    List<MessageBlock>? blocks,
    required this.createdAt,
  }) : blocks = blocks ?? [];
}
