import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/ws_message.dart';

class ChatRemoteDatasource {
  WebSocketChannel? _channel;
  final StreamController<WsServerMessage> _messageController =
      StreamController<WsServerMessage>.broadcast();
  String? _sessionId;

  Stream<WsServerMessage> get messageStream => _messageController.stream;
  bool get isConnected => _channel != null;
  String? get sessionId => _sessionId;

  Future<void> connect(String wsUrl, String ticket) async {
    final uri = Uri.parse('$wsUrl/ws?ticket=$ticket');
    _channel = WebSocketChannel.connect(uri);
    await _channel!.ready;

    _channel!.stream.listen(
      (data) {
        final json = jsonDecode(data as String) as Map<String, dynamic>;
        final msg = WsServerMessage.fromJson(json);
        if (msg.type == 'connected') {
          _sessionId = msg.sessionId;
        }
        _messageController.add(msg);
      },
      onError: (Object error) {
        _messageController.addError(error);
      },
      onDone: () {
        _channel = null;
      },
    );
  }

  void sendMessage({
    required String content,
    String? conversationId,
    String? clientMessageId,
    String? language,
    String? requestId,
  }) {
    final msg = WsClientMessage(
      type: 'user_message',
      content: content,
      conversationId: conversationId,
      clientMessageId: clientMessageId,
      language: language,
      id: requestId,
    );
    _channel?.sink.add(jsonEncode(msg.toJson()));
  }

  void sendPing() {
    _channel?.sink.add(jsonEncode({'type': 'ping'}));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
