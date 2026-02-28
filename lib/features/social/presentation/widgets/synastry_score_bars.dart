import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

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
          padding: const EdgeInsets.only(bottom: 10),
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
    final theme = Theme.of(context);
    final clampedScore = score.clamp(0, 100);
    final barColor = _scoreColor(clampedScore);

    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedScore / 100.0,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: barColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text(
            '$clampedScore%',
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: barColor,
            ),
          ),
        ),
      ],
    );
  }

  Color _scoreColor(int value) {
    if (value < 40) return Colors.red;
    if (value <= 60) return Colors.amber.shade700;
    return Colors.green;
  }
}
