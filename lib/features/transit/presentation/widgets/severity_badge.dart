import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (color, label) = _severityStyle(l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) _severityStyle(AppLocalizations l10n) {
    switch (severity.toLowerCase()) {
      case 'high':
        return (Colors.red, l10n.transitSeverityHigh);
      case 'medium':
        return (Colors.amber.shade700, l10n.transitSeverityMedium);
      case 'low':
      default:
        return (Colors.green, l10n.transitSeverityLow);
    }
  }
}
