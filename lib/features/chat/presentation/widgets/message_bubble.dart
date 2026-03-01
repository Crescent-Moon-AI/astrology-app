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
      child: isUser ? _buildUserBubble(context) : _buildAiBubble(context),
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
                  CosmicColors.primary.withValues(alpha: 0.4),
                  CosmicColors.primary.withValues(alpha: 0.25),
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
                color: CosmicColors.primary.withValues(alpha: 0.3),
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

  Widget _buildAiBubble(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CharacterAvatar(
          expression: mapBlocksToExpression(message.blocks),
          size: CharacterAvatarSize.sm,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CosmicColors.surfaceElevated,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: CosmicColors.borderGlow,
              ),
            ),
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
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                // AI disclaimer
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 11,
                      color: CosmicColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isZh ? 'AI生成 · 仅供参考' : 'AI Generated',
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}
