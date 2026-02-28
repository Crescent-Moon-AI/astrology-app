import '../../features/chat/domain/models/message.dart';

enum ExpressionId {
  greeting,
  thinking,
  happy,
  caring,
  mysterious,
  surprised,
  explaining,
  farewell,
}

/// Maps block state to the appropriate character expression.
ExpressionId mapBlocksToExpression(
  List<MessageBlock> blocks, {
  bool isFirstMessage = false,
}) {
  if (isFirstMessage) return ExpressionId.greeting;

  for (final block in blocks) {
    // Thinking or tool blocks that are still running -> thinking
    if (block.kind == BlockKind.thinking && block.status == BlockStatus.running) {
      return ExpressionId.thinking;
    }
    if (block.kind == BlockKind.tool && block.status == BlockStatus.running) {
      return ExpressionId.thinking;
    }
    // Tarot tool -> mysterious
    if (block.kind == BlockKind.tool) {
      final toolName = block.toolName ?? '';
      if (toolName.contains('tarot')) return ExpressionId.mysterious;
    }
  }

  // Check text blocks for length
  for (final block in blocks) {
    if (block.kind == BlockKind.text) {
      final text = block.contentText ?? '';
      if (text.length > 200) return ExpressionId.explaining;
    }
  }

  return ExpressionId.greeting;
}
