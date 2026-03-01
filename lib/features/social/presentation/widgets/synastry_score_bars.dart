import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class SynastryScoreBars extends StatelessWidget {
  final Map<String, int> scores;

  const SynastryScoreBars({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final labels = {
      'overall': l10n.synastryOverall,
      'emotional': l10n.synastryEmotional,
      'intellectual': l10n.synastryIntellectual,
      'physical': l10n.synastryPhysical,
      'spiritual': l10n.synastrySpiritual,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: labels.entries.map((entry) {
        final score = scores[entry.key] ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ScoreBar(
            label: entry.value,
            score: score,
          ),
        );
      }).toList(),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreBar({
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final clampedScore = score.clamp(0, 100);
    final barColor = _scoreColor(clampedScore);

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: CosmicColors.surface,
                ),
              ),
              // Progress
              FractionallySizedBox(
                widthFactor: clampedScore / 100.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        barColor.withValues(alpha: 0.7),
                        barColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text(
            '$clampedScore%',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: barColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Color _scoreColor(int value) {
    if (value < 40) return CosmicColors.error;
    if (value <= 60) return CosmicColors.warning;
    return CosmicColors.success;
  }
}
