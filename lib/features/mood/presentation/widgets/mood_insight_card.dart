import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/mood_insight.dart';

class MoodInsightCard extends StatelessWidget {
  final MoodInsight insight;

  const MoodInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isPositive = insight.delta >= 0;
    final deltaColor = isPositive ? CosmicColors.success : CosmicColors.error;
    final deltaSign = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: CosmicColors.surfaceElevated,
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transit name
          Text(
            insight.transitDisplayName,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            insight.transitAspectType,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
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
                  color: deltaColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: deltaColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '$deltaSign${insight.delta.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: deltaColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Avg mood score
              Text(
                'Avg: ${insight.avgMoodScore.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),

              // Sample count
              Text(
                'n=${insight.sampleCount}',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 12,
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
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _strengthColor(insight.strengthLabel)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  insight.strengthLabel,
                  style: TextStyle(
                    color: _strengthColor(insight.strengthLabel),
                    fontSize: 12,
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
                icon: const Icon(Icons.auto_awesome,
                    size: 16, color: CosmicColors.primaryLight),
                label: Text(
                  l10n.moodAskAi,
                  style: const TextStyle(color: CosmicColors.primaryLight),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _strengthColor(String label) {
    switch (label.toLowerCase()) {
      case 'strong':
        return CosmicColors.success;
      case 'moderate':
        return CosmicColors.warning;
      case 'weak':
        return CosmicColors.error;
      default:
        return CosmicColors.textTertiary;
    }
  }
}
