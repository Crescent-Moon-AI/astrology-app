import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/daily_fortune.dart';
import 'dimension_arc.dart';

/// Compact score display matching the real app layout:
/// Overall score on the left, dimension scores as arc rings on the right,
/// followed by fortune description paragraph.
class FortuneScoreSection extends StatelessWidget {
  final DailyFortune fortune;

  const FortuneScoreSection({super.key, required this.fortune});

  static const _dimensionColors = [
    Color(0xFFFF6B8A), // love
    Color(0xFF6C5CE7), // career
    Color(0xFFFDCB6E), // wealth
    Color(0xFF00CEC9), // study
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score row: overall score + dimension arc rings
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Overall score — tappable, opens detail page
              GestureDetector(
                onTap: () => context.push('/fortune/detail', extra: fortune),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fortune.overallScore}',
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.homeOverallScore,
                          style: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right,
                          color: CosmicColors.textTertiary,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Dimension arc rings
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < fortune.dimensions.length && i < 4; i++)
                      DimensionArc(
                        label: _dimensionLabel(fortune.dimensions[i].key, l10n),
                        score: fortune.dimensions[i].score,
                        color: _dimensionColors[i % _dimensionColors.length],
                        size: 62,
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Description paragraph
          if (fortune.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              fortune.description,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _dimensionLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'love':
        return l10n.homeDimensionLove;
      case 'career':
        return l10n.homeDimensionCareer;
      case 'wealth':
        return l10n.homeDimensionWealth;
      case 'study':
        return l10n.homeDimensionStudy;
      default:
        return key;
    }
  }
}
