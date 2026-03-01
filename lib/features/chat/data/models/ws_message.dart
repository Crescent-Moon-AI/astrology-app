/// Client -> Server WebSocket message.
class WsClientMessage {
  final String type;
  final String? content;
  final String? conversationId;
  final String? clientMessageId;
  final String? language;
  final String? id;
  final bool? debug;
  final String? scenarioId;

  WsClientMessage({
    required this.type,
    this.content,
    this.conversationId,
    this.clientMessageId,
    this.language,
    this.id,
    this.debug,
    this.scenarioId,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        if (content != null) 'content': content,
        if (conversationId != null) 'conversation_id': conversationId,
        if (clientMessageId != null) 'client_message_id': clientMessageId,
        if (language != null) 'language': language,
        if (id != null) 'id': id,
        if (debug != null) 'debug': debug,
        if (scenarioId != null) 'scenario_id': scenarioId,
      };
}

/// Server -> Client WebSocket message.
class WsServerMessage {
  final String type;
  final String? sessionId;
  final String? conversationId;
  final String? requestId;
  final String? messageId;
  final String? clientMessageId;
  final String? content;
  final String? delta;
  final int? index;
  final String? status;
  final String? error;
  final String? code;
  final String? message;
  final String? blockId;
  final String? stopReason;
  final Map<String, dynamic>? block;
  final Map<String, dynamic>? blockMetadata;
  final Map<String, dynamic>? usage;

  WsServerMessage({
    required this.type,
    this.sessionId,
    this.conversationId,
    this.requestId,
    this.messageId,
    this.clientMessageId,
    this.content,
    this.delta,
    this.index,
    this.status,
    this.error,
    this.code,
    this.message,
    this.blockId,
    this.stopReason,
    this.block,
    this.blockMetadata,
    this.usage,
  });

  factory WsServerMessage.fromJson(Map<String, dynamic> json) {
    return WsServerMessage(
      type: json['type'] as String,
      sessionId: json['session_id'] as String?,
      conversationId: json['conversation_id'] as String?,
      requestId: json['request_id'] as String?,
      messageId: json['message_id'] as String?,
      clientMessageId: json['client_message_id'] as String?,
      content: json['content'] as String?,
      delta: json['delta'] as String?,
      index: json['index'] as int?,
      status: json['status'] as String?,
      error: json['error'] as String?,
      code: json['code'] as String?,
      message: json['message'] as String?,
      blockId: json['block_id'] as String?,
      stopReason: json['stop_reason'] as String?,
      block: json['block'] as Map<String, dynamic>?,
      blockMetadata: json['block_metadata'] as Map<String, dynamic>?,
      usage: json['usage'] as Map<String, dynamic>?,
    );
  }
}
