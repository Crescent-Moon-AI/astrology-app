import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/message.dart';
import '../../domain/utils/section_parser.dart';
import 'progressive_text_block.dart';
import 'tool_result_card.dart';

class BlockRenderer extends StatelessWidget {
  final MessageBlock block;
  final ScrollController? scrollController;

  const BlockRenderer({
    super.key,
    required this.block,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    switch (block.kind) {
      case BlockKind.text:
        final text = block.contentText ?? '';
        if (hasSectionMarkers(text)) {
          return ProgressiveTextBlock(
            block: block,
            scrollController: scrollController,
          );
        }
        return MarkdownBody(data: text);

      case BlockKind.tool:
        return ToolResultCard(block: block);

      case BlockKind.thinking:
        // Hidden by default; could show in debug mode
        return const SizedBox.shrink();
    }
  }
}
