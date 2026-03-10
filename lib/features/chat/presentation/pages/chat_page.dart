import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/utils/error_format.dart';
import '../../../../shared/theme/cosmic_colors.dart';
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
  final String? prefillMessage;
  final String? tarotSessionId;
  final String? imageData;
  final String? imageMediaType;

  const ChatPage({
    super.key,
    this.conversationId,
    this.scenarioId,
    this.initialMessage,
    this.prefillMessage,
    this.tarotSessionId,
    this.imageData,
    this.imageMediaType,
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

    // When starting a new chat (no conversationId), clear any leftover
    // messages from a previous session stored under the empty key.
    if (widget.conversationId == null) {
      Future.microtask(() {
        ref.invalidate(chatMessagesProvider(''));
      });
    } else {
      // Load existing messages for this conversation
      _loadExistingMessages(widget.conversationId!);
    }

    _connectWebSocket();
  }

  Future<void> _loadExistingMessages(String conversationId) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final messages = await repo.getMessages(conversationId);
      if (mounted) {
        final notifier = ref.read(
          chatMessagesProvider(conversationId).notifier,
        );
        for (final msg in messages) {
          notifier.addExistingMessage(msg);
        }
      }
    } catch (e) {
      // History load failure is non-fatal; user can still send new messages
      debugPrint('Failed to load existing messages: $e');
    }
  }

  Future<void> _connectWebSocket() async {
    final datasource = ref.read(chatDatasourceProvider);
    final repo = ref.read(chatRepositoryProvider);

    _wsSubscription = datasource.messageStream.listen(_handleServerMessage);

    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      if (!mounted) return;

      try {
        final ticket = await repo.getWsTicket().timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw TimeoutException('WebSocket ticket request timed out'),
        );
        await datasource
            .connect(ApiConstants.wsUrl, ticket)
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () =>
                  throw TimeoutException('WebSocket connection timed out'),
            );

        if (mounted) {
          setState(() {
            _wsConnected = true;
            _wsError = null;
          });
          _sendInitialMessageIfNeeded();
        }
        return; // success
      } catch (e) {
        // On timeout, the underlying connect() may still be running —
        // disconnect explicitly to clean up before retrying.
        datasource.disconnect();

        if (attempt >= maxAttempts) {
          if (mounted) {
            setState(() {
              _wsError = formatError(e);
            });
          }
        } else {
          // Brief pause before retrying (WebView engine should be warm now)
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }
    }
  }

  void _sendInitialMessageIfNeeded() {
    final msg = widget.initialMessage;
    final imgData = widget.imageData;

    if (imgData != null && imgData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(msg?.isNotEmpty == true ? msg! : '请帮我解读这张星盘图片',
            imageData: imgData, imageMediaType: widget.imageMediaType);
      });
    } else if (msg != null && msg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(msg);
      });
    }
  }

  void _handleServerMessage(WsServerMessage msg) {
    switch (msg.type) {
      case 'conversation_created':
        final oldKey = _currentConversationId ?? '';
        final newKey = msg.conversationId ?? '';
        if (newKey.isNotEmpty && newKey != oldKey) {
          // Transfer messages from temporary key to the real conversation key
          final oldMessages = ref.read(chatMessagesProvider(oldKey));
          final newNotifier = ref.read(chatMessagesProvider(newKey).notifier);
          for (final m in oldMessages) {
            newNotifier.addExistingMessage(m);
          }
          // Clear the temporary key so it doesn't show stale data next time
          ref.invalidate(chatMessagesProvider(oldKey));
        }
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

  void _sendMessage(String content, {String? imageData, String? imageMediaType}) {
    final datasource = ref.read(chatDatasourceProvider);
    if (!datasource.isConnected) return;

    final notifier = ref.read(
      chatMessagesProvider(_currentConversationId ?? '').notifier,
    );

    Uint8List? imageBytes;
    if (imageData != null && imageData.isNotEmpty) {
      imageBytes = base64Decode(imageData);
    }

    notifier.addUserMessage(content, imageBytes: imageBytes);
    setState(() => _isProcessing = true);

    datasource.sendMessage(
      content: content,
      conversationId: _currentConversationId,
      language: Localizations.localeOf(context).languageCode,
      scenarioId: _currentConversationId == null ? widget.scenarioId : null,
      imageData: imageData,
      imageMediaType: imageMediaType,
    );

    _autoScroll.scrollToBottom();
  }

  void _retryConnection() {
    setState(() {
      _wsError = null;
      _wsConnected = false;
    });
    _wsSubscription?.cancel();
    ref.read(chatDatasourceProvider).disconnect();
    _connectWebSocket();
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
    final messages = ref.watch(
      chatMessagesProvider(_currentConversationId ?? ''),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.tarotSessionId != null) {
              context.go('/home');
            } else if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
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
            Expanded(
              child: messages.isEmpty && !_isProcessing
                  ? _buildEmptyState(context, l10n)
                  : ListView.builder(
                      controller: _autoScroll.scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length + (_isProcessing ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return _buildWaitingIndicator(context);
                        }
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CosmicColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CosmicColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: CosmicColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _wsError!,
                        style: const TextStyle(
                          color: CosmicColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _retryConnection,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CosmicColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          Localizations.localeOf(
                                context,
                              ).languageCode.startsWith('zh')
                              ? '重试'
                              : 'Retry',
                          style: const TextStyle(
                            color: CosmicColors.primaryLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ChatInput(
              onSend: _sendMessage,
              enabled: _wsConnected && !_isProcessing,
              initialText: widget.prefillMessage,
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
      return const Center(
        child: CharacterAvatar(
          expression: ExpressionId.thinking,
          size: CharacterAvatarSize.lg,
        ),
      );
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
              isZh
                  ? '\u6709\u4EC0\u4E48\u60F3\u95EE\u7684\uFF1F'
                  : 'What would you like to ask?',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
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

  Widget _buildWaitingIndicator(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CharacterAvatar(
            expression: ExpressionId.thinking,
            size: CharacterAvatarSize.lg,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: CosmicColors.textTertiary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isZh ? '感受平静...' : 'Feeling calm...',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
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
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primary.withAlpha(13), // 5%
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
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
