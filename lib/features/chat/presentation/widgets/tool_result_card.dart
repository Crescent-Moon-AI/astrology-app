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

  String get _toolDisplayName => widget.block.toolName ?? 'Tool';

  String get _statusIcon {
    switch (widget.block.status) {
      case BlockStatus.running:
        return '\u23F3'; // hourglass
      case BlockStatus.success:
        return '\u2705'; // check mark
      case BlockStatus.error:
        return '\u274C'; // cross mark
      default:
        return '\uD83D\uDD27'; // wrench
    }
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
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
                    color: CosmicColors.textPrimary,
                    fontSize: 14,
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
                    color: CosmicColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  const JsonEncoder.withIndent('  ').convert(_parsedPayload),
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
              onPressed: () => setState(() => _showDetails = !_showDetails),
              child: Text(
                _showDetails
                    ? (l10n?.cardHideDetails ?? 'Hide Details')
                    : (l10n?.cardShowDetails ?? 'Show Details'),
                style: const TextStyle(color: CosmicColors.primaryLight),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
