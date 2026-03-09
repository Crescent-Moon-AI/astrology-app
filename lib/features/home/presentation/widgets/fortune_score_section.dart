import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/daily_fortune.dart';

/// Compact score display matching the real app layout:
/// Overall score on the left, dimension scores as bordered badges on the right,
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
          // Score row: overall score + dimension badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              const SizedBox(width: 16),
              // Dimension score badges
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < fortune.dimensions.length && i < 4; i++)
                      _buildDimensionBadge(
                        fortune.dimensions[i],
                        _dimensionColors[i % _dimensionColors.length],
                        l10n,
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

  Widget _buildDimensionBadge(
    FortuneDimension dim,
    Color color,
    AppLocalizations l10n,
  ) {
    final label = _dimensionLabel(dim.key, l10n);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(128), width: 1.5),
          ),
          child: Text(
            '${dim.score}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: CosmicColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
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
