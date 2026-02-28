import 'package:flutter/material.dart';

import 'package:astrology_app/shared/models/expression.dart';
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
    final theme = Theme.of(context);
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CharacterAvatar(
              expression: mapBlocksToExpression(message.blocks),
              size: CharacterAvatarSize.md,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16).copyWith(
                  topLeft: isUser ? null : const Radius.circular(4),
                  topRight: isUser ? const Radius.circular(4) : null,
                ),
              ),
              child: isUser
                  ? Text(
                      message.content ?? '',
                      style: theme.textTheme.bodyMedium,
                    )
                  : Column(
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
                            style: theme.textTheme.bodyMedium,
                          ),
                      ],
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
