import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../data/models/ws_message.dart';
import '../controllers/auto_scroll_controller.dart';
import '../providers/chat_providers.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String? conversationId;
  final String? scenarioId;

  const ChatPage({super.key, this.conversationId, this.scenarioId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late AutoScrollController _autoScroll;
  StreamSubscription<WsServerMessage>? _wsSubscription;
  String? _currentConversationId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _autoScroll = AutoScrollController();
    _currentConversationId = widget.conversationId;
    _setupWebSocket();
  }

  void _setupWebSocket() {
    final datasource = ref.read(chatDatasourceProvider);
    _wsSubscription = datasource.messageStream.listen(_handleServerMessage);
  }

  void _handleServerMessage(WsServerMessage msg) {
    switch (msg.type) {
      case 'conversation_created':
        setState(() {
          _currentConversationId = msg.conversationId;
        });

      case 'message_ack':
        break;

      case 'block_upsert':
        if (msg.messageId != null && msg.block != null) {
          final notifier = ref.read(
            chatMessagesProvider(_currentConversationId ?? '').notifier,
          );
          notifier.ensureAssistantMessage(msg.messageId!);
          notifier.handleBlockUpsert(msg.block!, msg.messageId!);
        }

      case 'block_delta':
        if (msg.blockId != null && msg.delta != null) {
          final notifier = ref.read(
            chatMessagesProvider(_currentConversationId ?? '').notifier,
          );
          notifier.handleBlockDelta(msg.blockId!, msg.delta!);
          if (_autoScroll.isAtBottom) {
            _autoScroll.scrollToBottom();
          }
        }

      case 'block_done':
        if (msg.blockId != null) {
          final notifier = ref.read(
            chatMessagesProvider(_currentConversationId ?? '').notifier,
          );
          notifier.handleBlockDone(
            msg.blockId!,
            msg.content ?? '',
            msg.blockMetadata,
          );
        }

      case 'response_done':
        setState(() => _isProcessing = false);

      case 'error':
        setState(() => _isProcessing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg.message ?? 'An error occurred')),
          );
        }
    }
  }

  void _sendMessage(String content) {
    final datasource = ref.read(chatDatasourceProvider);
    final notifier = ref.read(
      chatMessagesProvider(_currentConversationId ?? '').notifier,
    );

    notifier.addUserMessage(content);
    setState(() => _isProcessing = true);

    datasource.sendMessage(
      content: content,
      conversationId: _currentConversationId,
      language: Localizations.localeOf(context).languageCode,
    );

    _autoScroll.scrollToBottom();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _autoScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final messages =
        ref.watch(chatMessagesProvider(_currentConversationId ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.chatTitle ?? 'Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _autoScroll.scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: messages[index],
                  scrollController: _autoScroll.scrollController,
                );
              },
            ),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: LinearProgressIndicator(),
            ),
          ChatInput(
            onSend: _sendMessage,
            enabled: !_isProcessing,
          ),
        ],
      ),
    );
  }
}
