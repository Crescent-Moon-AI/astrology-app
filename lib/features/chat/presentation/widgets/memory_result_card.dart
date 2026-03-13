import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

/// Structured display for recall_memory tool results.
///
/// Shows a summary line, memory count, and a compact list of recalled memories.
class MemoryResultCard extends StatelessWidget {
  final String payloadJson;

  const MemoryResultCard({super.key, required this.payloadJson});

  @override
  Widget build(BuildContext context) {
    final data = _parse();
    if (data == null) return const SizedBox.shrink();

    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Header: count + query
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CosmicColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${data.count} ${isZh ? "条记忆" : "memories"}',
                style: const TextStyle(
                  color: CosmicColors.primaryLight,
                  fontSize: 10,
                ),
              ),
            ),
            if (data.query.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.query,
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        // Summary
        if (data.summary.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            data.summary,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        // Memory items (show up to 3)
        ...data.memories.take(3).map((m) => _MemoryItem(memory: m)),
        if (data.memories.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              isZh
                  ? '...还有 ${data.memories.length - 3} 条'
                  : '...and ${data.memories.length - 3} more',
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  _MemoryData? _parse() {
    try {
      final json = jsonDecode(payloadJson) as Map<String, dynamic>;
      final data = (json['data'] ?? json) as Map<String, dynamic>;
      return _MemoryData.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

class _MemoryItem extends StatelessWidget {
  final _Memory memory;

  const _MemoryItem({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CosmicColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: CosmicColors.primary.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type + subject
            Row(
              children: [
                _typeIcon(memory.type),
                const SizedBox(width: 4),
                if (memory.subject.isNotEmpty)
                  Text(
                    memory.subject,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const Spacer(),
                if (memory.pinned)
                  const Icon(
                    Icons.push_pin,
                    size: 12,
                    color: CosmicColors.primaryLight,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              memory.contentText,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeIcon(String type) {
    final (IconData icon, Color color) = switch (type) {
      'preference' => (Icons.favorite_border, Colors.pink.shade300),
      'fact' => (Icons.info_outline, Colors.blue.shade300),
      'event' => (Icons.event, Colors.amber.shade300),
      'insight' => (Icons.lightbulb_outline, Colors.purple.shade300),
      _ => (Icons.memory, CosmicColors.textTertiary),
    };
    return Icon(icon, size: 14, color: color);
  }
}

class _MemoryData {
  final int count;
  final String query;
  final String summary;
  final List<_Memory> memories;

  _MemoryData({
    required this.count,
    required this.query,
    required this.summary,
    required this.memories,
  });

  factory _MemoryData.fromJson(Map<String, dynamic> json) {
    final items = (json['memories'] as List<dynamic>?)
            ?.map((m) => _Memory.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];
    return _MemoryData(
      count: json['count'] as int? ?? items.length,
      query: json['query'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      memories: items,
    );
  }
}

class _Memory {
  final String type;
  final String subject;
  final String contentText;
  final bool pinned;

  _Memory({
    required this.type,
    required this.subject,
    required this.contentText,
    required this.pinned,
  });

  factory _Memory.fromJson(Map<String, dynamic> json) {
    return _Memory(
      type: json['type'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      contentText: json['content_text'] as String? ?? '',
      pinned: json['pinned'] as bool? ?? false,
    );
  }
}
