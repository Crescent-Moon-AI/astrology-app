import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/models/expression.dart';
import '../../data/models/ws_message.dart';
import '../controllers/auto_scroll_controller.dart';
import '../providers/chat_providers.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String? conversationId;
  final String? scenarioId;
  final String? initialMessage;

  const ChatPage({
    super.key,
    this.conversationId,
    this.scenarioId,
    this.initialMessage,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late AutoScrollController _autoScroll;
  StreamSubscription<WsServerMessage>? _wsSubscription;
  String? _currentConversationId;
  bool _isProcessing = false;
  bool _wsConnected = false;
  String? _wsError;

  @override
  void initState() {
    super.initState();
    _autoScroll = AutoScrollController();
    _currentConversationId = widget.conversationId;
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    final datasource = ref.read(chatDatasourceProvider);
    final repo = ref.read(chatRepositoryProvider);

    _wsSubscription = datasource.messageStream.listen(_handleServerMessage);

    try {
      final ticket = await repo.getWsTicket();
      final httpUri = Uri.parse(ApiConstants.baseUrl);
      final wsScheme = httpUri.scheme == 'https' ? 'wss' : 'ws';
      final wsBaseUrl = '$wsScheme://${httpUri.host}:${httpUri.port}';

      await datasource.connect(wsBaseUrl, ticket);

      if (mounted) {
        setState(() => _wsConnected = true);
        _sendInitialMessageIfNeeded();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _wsError = e.toString();
        });
      }
    }
  }

  void _sendInitialMessageIfNeeded() {
    final msg = widget.initialMessage;
    if (msg != null && msg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(msg);
      });
    }
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
    if (!datasource.isConnected) return;

    final notifier = ref.read(
      chatMessagesProvider(_currentConversationId ?? '').notifier,
    );

    notifier.addUserMessage(content);
    setState(() => _isProcessing = true);

    datasource.sendMessage(
      content: content,
      conversationId: _currentConversationId,
      language: Localizations.localeOf(context).languageCode,
      scenarioId:
          _currentConversationId == null ? widget.scenarioId : null,
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
        title: Text(
          l10n?.chatTitle ?? '咨询',
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CosmicColors.background.withValues(alpha: 0.95),
        centerTitle: true,
      ),
      body: StarfieldBackground(
        child: Column(
          children: [
            if (_isProcessing)
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: CosmicColors.primaryGradient,
                ),
              ),
            Expanded(
              child: messages.isEmpty && !_isProcessing
                  ? _buildEmptyState(context, l10n)
                  : ListView.builder(
                      controller: _autoScroll.scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          message: messages[index],
                          scrollController: _autoScroll.scrollController,
                        );
                      },
                    ),
            ),
            if (_wsError != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CosmicColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CosmicColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 16, color: CosmicColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _wsError!,
                        style: const TextStyle(
                            color: CosmicColors.error, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ChatInput(
              onSend: _sendMessage,
              enabled: _wsConnected && !_isProcessing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations? l10n) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    if (!_wsConnected && _wsError == null) {
      return const Center(child: BreathingLoader());
    }

    // Preset topic tags
    final topics = isZh
        ? [
            _TopicTag('\u2764\uFE0F', '感情'),
            _TopicTag('\uD83D\uDCBC', '事业'),
            _TopicTag('\u2728', '运势'),
            _TopicTag('\uD83C\uDCCF', '塔罗'),
            _TopicTag('\uD83C\uDF31', '成长'),
            _TopicTag('\uD83D\uDCB0', '财运'),
          ]
        : [
            _TopicTag('\u2764\uFE0F', 'Love'),
            _TopicTag('\uD83D\uDCBC', 'Career'),
            _TopicTag('\u2728', 'Fortune'),
            _TopicTag('\uD83C\uDCCF', 'Tarot'),
            _TopicTag('\uD83C\uDF31', 'Growth'),
            _TopicTag('\uD83D\uDCB0', 'Wealth'),
          ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CharacterAvatar(
              expression: ExpressionId.greeting,
              size: CharacterAvatarSize.lg,
            ),
            const SizedBox(height: 20),
            Text(
              isZh ? '有什么想问的？' : 'What would you like to ask?',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isZh
                  ? '写下你的问题，让星象为你指引方向'
                  : 'Write your question and let the stars guide you',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Preset topic tags
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: topics
                  .map((t) => _buildTopicChip(context, t, isZh))
                  .toList(),
            ),
            const SizedBox(height: 32),
            // AI disclaimer
            Text(
              isZh
                  ? '以上内容均由AI生成，仅供参考和娱乐'
                  : 'All content is AI-generated, for reference and entertainment only',
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(BuildContext context, _TopicTag tag, bool isZh) {
    return GestureDetector(
      onTap: () {
        final prompt = isZh
            ? '我想聊聊关于${tag.label}的问题'
            : 'I want to talk about ${tag.label}';
        _sendMessage(prompt);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              tag.label,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicTag {
  final String emoji;
  final String label;
  const _TopicTag(this.emoji, this.label);
}
