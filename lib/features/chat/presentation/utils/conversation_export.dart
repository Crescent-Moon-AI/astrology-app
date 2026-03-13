import 'package:flutter/services.dart';

import '../../domain/models/message.dart';

/// Converts a list of chat messages into a readable text format.
String exportConversationAsText(
  List<ChatMessage> messages, {
  String? title,
  bool isZh = true,
}) {
  final buf = StringBuffer();

  // Header
  buf.writeln(title ?? (isZh ? '对话记录' : 'Conversation'));
  buf.writeln(
      isZh ? '导出时间: ${DateTime.now()}' : 'Exported: ${DateTime.now()}');
  buf.writeln('${'─' * 40}\n');

  for (final msg in messages) {
    final roleLabel = msg.role == MessageRole.user
        ? (isZh ? '👤 我' : '👤 Me')
        : (isZh ? '✨ 月见' : '✨ Yuejian');
    buf.writeln(roleLabel);

    // User messages: use content directly
    if (msg.role == MessageRole.user) {
      if (msg.content != null && msg.content!.isNotEmpty) {
        buf.writeln(msg.content);
      }
    } else {
      // Assistant messages: extract text from blocks
      for (final block in msg.blocks) {
        if (block.kind == BlockKind.text &&
            block.contentText != null &&
            block.contentText!.isNotEmpty) {
          buf.writeln(block.contentText);
        }
      }
    }

    buf.writeln();
  }

  final divider = '─' * 40;
  buf.writeln(divider);
  buf.writeln(isZh
      ? '以上内容由 AI 生成，仅供参考和娱乐'
      : 'AI-generated content, for reference and entertainment only');

  return buf.toString();
}

/// Copy conversation text to clipboard.
Future<void> copyConversationToClipboard(
  List<ChatMessage> messages, {
  String? title,
  bool isZh = true,
}) async {
  final text = exportConversationAsText(messages, title: title, isZh: isZh);
  await Clipboard.setData(ClipboardData(text: text));
}
