import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.block.durationMs != null)
                  Text(
                    '${(widget.block.durationMs! / 1000).toStringAsFixed(1)}s',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
            // Error message
            if (widget.block.error != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.block.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
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
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    const JsonEncoder.withIndent('  ').convert(_parsedPayload),
                    style: theme.textTheme.bodySmall?.copyWith(
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
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
