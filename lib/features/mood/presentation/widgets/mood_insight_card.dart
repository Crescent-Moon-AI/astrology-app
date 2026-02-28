import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/mood_insight.dart';

class MoodInsightCard extends StatelessWidget {
  final MoodInsight insight;

  const MoodInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final isPositive = insight.delta >= 0;
    final deltaColor = isPositive ? const Color(0xFF38A169) : const Color(0xFFE53E3E);
    final deltaSign = isPositive ? '+' : '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transit name
            Text(
              insight.transitDisplayName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              insight.transitAspectType,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Delta and average score
            Row(
              children: [
                // Delta from average
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: deltaColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$deltaSign${insight.delta.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: deltaColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Avg mood score
                Text(
                  'Avg: ${insight.avgMoodScore.toStringAsFixed(1)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),

                // Sample count
                Text(
                  'n=${insight.sampleCount}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Strength label badge + Ask AI button
            Row(
              children: [
                // Strength label badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _strengthColor(insight.strengthLabel)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    insight.strengthLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _strengthColor(insight.strengthLabel),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),

                // Ask AI button
                TextButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      'chat',
                      queryParameters: {'scenario_id': 'mood_insight'},
                    );
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: Text(l10n.moodAskAi),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _strengthColor(String label) {
    switch (label.toLowerCase()) {
      case 'strong':
        return const Color(0xFF38A169);
      case 'moderate':
        return const Color(0xFFED8936);
      case 'weak':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF718096);
    }
  }
}
