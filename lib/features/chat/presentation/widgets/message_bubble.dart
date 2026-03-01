import 'package:flutter/material.dart';

import 'package:astrology_app/shared/models/expression.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import 'package:astrology_app/shared/widgets/character_avatar.dart';
import '../../domain/models/message.dart';
import 'block_renderer.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ScrollController? scrollController;

  const MessageBubble({
    super.key,
    required this.message,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: isUser ? _buildUserBubble(context) : _buildAiCard(context),
    );
  }

  Widget _buildUserBubble(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 48),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CosmicColors.primary.withAlpha(128), // 50%
                  CosmicColors.primary.withAlpha(89), // 35%
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: CosmicColors.primary.withAlpha(77), // 30%
              ),
            ),
            child: Text(
              message.content ?? '',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiCard(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar centered
        CharacterAvatar(
          expression: mapBlocksToExpression(message.blocks),
          size: CharacterAvatarSize.md,
        ),
        const SizedBox(height: 12),

        // Content blocks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final block in message.blocks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: BlockRenderer(
                    block: block,
                    scrollController: scrollController,
                  ),
                ),
              if (message.blocks.isEmpty && message.content != null)
                Text(
                  message.content!,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
            ],
          ),
        ),

        // AI disclaimer — right-aligned
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 11,
                color: CosmicColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                isZh
                    ? 'AI\u751F\u6210 \u00B7 \u4EC5\u4F9B\u53C2\u8003'
                    : 'AI Generated',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
