import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/models/expression.dart';

class TarotQuestionPage extends StatefulWidget {
  final String conversationId;
  final String tarotSessionId;

  const TarotQuestionPage({
    super.key,
    required this.conversationId,
    required this.tarotSessionId,
  });

  @override
  State<TarotQuestionPage> createState() => _TarotQuestionPageState();
}

class _TarotQuestionPageState extends State<TarotQuestionPage> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.pushNamed(
      'chatConversation',
      pathParameters: {'id': widget.conversationId},
      queryParameters: {
        'tarot_session_id': widget.tarotSessionId,
        'initial_message': text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      backgroundColor: CosmicColors.backgroundDeep,
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Content area
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CharacterAvatar(
                          expression: ExpressionId.mysterious,
                          size: CharacterAvatarSize.lg,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          isZh ? '想问卡牌吗？' : 'Ask the cards?',
                          style: const TextStyle(
                            color: CosmicColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isZh
                              ? '卡牌能看当下能量和短期趋势，给你具体建议'
                              : 'Cards reveal current energy and short-term trends with specific advice',
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Input area
              Container(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 8,
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                ),
                decoration: BoxDecoration(
                  color: CosmicColors.backgroundDeep.withAlpha(230),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        maxLines: 4,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submit(),
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: isZh
                              ? '在这里写下你的问题'
                              : 'Write your question here',
                          hintStyle: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: CosmicColors.borderGlow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: CosmicColors.borderGlow,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: CosmicColors.primary,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: CosmicColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            _hasText ? CosmicColors.primaryGradient : null,
                        color: _hasText ? null : CosmicColors.surface,
                      ),
                      child: IconButton(
                        onPressed: _hasText ? _submit : null,
                        icon: Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: _hasText
                              ? CosmicColors.textPrimary
                              : CosmicColors.textTertiary,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
