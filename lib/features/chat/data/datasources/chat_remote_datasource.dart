import 'dart:async';
import 'dart:convert';

import '../../../../core/network/native_websocket.dart';
import '../models/ws_message.dart';

class ChatRemoteDatasource {
  NativeWebSocket? _ws;
  final StreamController<WsServerMessage> _messageController =
      StreamController<WsServerMessage>.broadcast();
  String? _sessionId;

  Stream<WsServerMessage> get messageStream => _messageController.stream;
  bool get isConnected => _ws?.isConnected ?? false;
  String? get sessionId => _sessionId;

  Future<void> connect(String wsUrl, String ticket) async {
    _ws?.dispose();
    _ws = NativeWebSocket();

    final uri = '$wsUrl/ws?ticket=$ticket';
    await _ws!.connect(uri);
    await _ws!.ready;

    _ws!.stream.listen(
      (data) {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final msg = WsServerMessage.fromJson(json);
        if (msg.type == 'connected') {
          _sessionId = msg.sessionId;
        }
        _messageController.add(msg);
      },
      onError: (Object error) {
        _messageController.addError(error);
      },
    );

    _ws!.done.listen((_) {
      _ws = null;
    });
  }

  void sendMessage({
    required String content,
    String? conversationId,
    String? clientMessageId,
    String? language,
    String? requestId,
    String? scenarioId,
  }) {
    final msg = WsClientMessage(
      type: 'user_message',
      content: content,
      conversationId: conversationId,
      clientMessageId: clientMessageId,
      language: language,
      id: requestId,
      scenarioId: scenarioId,
    );
    _ws?.send(jsonEncode(msg.toJson()));
  }

  void sendPing() {
    _ws?.send(jsonEncode({'type': 'ping'}));
  }

  void disconnect() {
    _ws?.disconnect();
    _ws = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
