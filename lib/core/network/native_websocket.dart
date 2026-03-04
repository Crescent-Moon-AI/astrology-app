import 'dart:async';

import 'package:flutter/services.dart';

/// Native WebSocket client using OkHttp on Android.
/// Bypasses Dart's BoringSSL TLS 1.2 limitation for proper TLS 1.3 support.
class NativeWebSocket {
  static const _method = MethodChannel('native_websocket');
  static const _events = EventChannel('native_websocket/events');

  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  final StreamController<void> _doneController =
      StreamController<void>.broadcast();

  StreamSubscription<dynamic>? _eventSub;
  bool _connected = false;
  final Completer<void> _readyCompleter = Completer<void>();

  Stream<String> get stream => _messageController.stream;
  Stream<void> get done => _doneController.stream;
  Future<void> get ready => _readyCompleter.future;
  bool get isConnected => _connected;

  Future<void> connect(String url) async {
    _eventSub = _events.receiveBroadcastStream().listen((event) {
      final map = Map<String, dynamic>.from(event as Map);
      switch (map['type']) {
        case 'open':
          _connected = true;
          if (!_readyCompleter.isCompleted) _readyCompleter.complete();
        case 'message':
          _messageController.add(map['data'] as String);
        case 'closed':
          _connected = false;
          _doneController.add(null);
        case 'error':
          _connected = false;
          final msg = map['message'] as String? ?? 'WebSocket error';
          if (!_readyCompleter.isCompleted) {
            _readyCompleter.completeError(Exception(msg));
          }
          _messageController.addError(Exception(msg));
          _doneController.add(null);
      }
    });

    await _method.invokeMethod('connect', {'url': url});
  }

  Future<void> send(String message) async {
    await _method.invokeMethod('send', {'message': message});
  }

  Future<void> disconnect() async {
    _connected = false;
    await _method.invokeMethod('disconnect');
    await _eventSub?.cancel();
    _eventSub = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _doneController.close();
  }
}
