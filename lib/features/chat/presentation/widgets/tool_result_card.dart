import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/message.dart';

class ToolResultCard extends StatefulWidget {
  final MessageBlock block;

  const ToolResultCard({super.key, required this.block});

  @override
  State<ToolResultCard> createState() => _ToolResultCardState();
}

class _ToolResultCardState extends State<ToolResultCard> {
  bool _showDetails = false;

  String get _toolDisplayName {
    final name = widget.block.toolName ?? 'Tool';
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    if (!isZh) return name;
    return switch (name) {
      'tarot_reading' || 'tarot' => '\u5854\u7F57\u5360\u535C',
      'natal_chart' => '\u661F\u76D8\u5206\u6790',
      'synastry' => '\u5408\u76D8\u5206\u6790',
      'transit' => '\u884C\u661F\u8FC7\u5883',
      'dice_divination' => '\u9AB0\u5B50\u5360\u535C',
      'numerology_analysis' => '\u6570\u5B57\u547D\u7406',
      'rune_reading' => '\u7B26\u6587\u5360\u535C',
      'lenormand_reading' => '\u96F7\u8BFA\u66FC\u724C',
      'iching_divination' => '\u6613\u7ECF\u5360\u535C',
      'meihua_divination' => '\u6885\u82B1\u6613\u6570',
      _ => name,
    };
  }

  Color get _statusColor {
    return switch (widget.block.status) {
      BlockStatus.running => CosmicColors.primary,
      BlockStatus.success => CosmicColors.success,
      BlockStatus.error => CosmicColors.error,
      _ => CosmicColors.textTertiary,
    };
  }

  String get _statusIcon {
    return switch (widget.block.status) {
      BlockStatus.running => '\u23F3', // hourglass
      BlockStatus.success => '\u2705', // check mark
      BlockStatus.error => '\u274C', // cross mark
      _ => '\uD83D\uDD27', // wrench
    };
  }

  Map<String, dynamic>? get _parsedPayload {
    if (widget.block.payloadJson == null) return null;
    try {
      return jsonDecode(widget.block.payloadJson!) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left color bar
          Container(
            width: 3,
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary row
                  Row(
                    children: [
                      Text(_statusIcon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _toolDisplayName,
                          style: const TextStyle(
                            color: CosmicColors.primaryLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (widget.block.durationMs != null)
                        Text(
                          '${(widget.block.durationMs! / 1000).toStringAsFixed(1)}s',
                          style: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  // Error message
                  if (widget.block.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.block.error!,
                      style: const TextStyle(
                        color: CosmicColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  // Detail toggle
                  if (widget.block.status == BlockStatus.success &&
                      _parsedPayload != null) ...[
                    const SizedBox(height: 8),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CosmicColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: CosmicColors.primary.withAlpha(51), // 20%
                          ),
                        ),
                        child: Text(
                          const JsonEncoder.withIndent(
                            '  ',
                          ).convert(_parsedPayload),
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      crossFadeState: _showDetails
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _showDetails = !_showDetails),
                      child: Text(
                        _showDetails
                            ? (l10n?.cardHideDetails ?? 'Hide Details')
                            : (l10n?.cardShowDetails ?? 'Show Details'),
                        style: const TextStyle(
                          color: CosmicColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
