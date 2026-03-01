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
  final BlockStatus? status;
  final String? contentText;
  final String? payloadJson;
  final String? toolCallId;
  final String? toolName;
  final String? error;
  final int? durationMs;
  final BlockMetadata? metadata;

  const MessageBlock({
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

  MessageBlock copyWith({
    String? id,
    int? idx,
    BlockKind? kind,
    BlockStatus? Function()? status,
    String? Function()? contentText,
    String? Function()? payloadJson,
    String? Function()? toolCallId,
    String? Function()? toolName,
    String? Function()? error,
    int? Function()? durationMs,
    BlockMetadata? Function()? metadata,
  }) {
    return MessageBlock(
      id: id ?? this.id,
      idx: idx ?? this.idx,
      kind: kind ?? this.kind,
      status: status != null ? status() : this.status,
      contentText: contentText != null ? contentText() : this.contentText,
      payloadJson: payloadJson != null ? payloadJson() : this.payloadJson,
      toolCallId: toolCallId != null ? toolCallId() : this.toolCallId,
      toolName: toolName != null ? toolName() : this.toolName,
      error: error != null ? error() : this.error,
      durationMs: durationMs != null ? durationMs() : this.durationMs,
      metadata: metadata != null ? metadata() : this.metadata,
    );
  }
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
