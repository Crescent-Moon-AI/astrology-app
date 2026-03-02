import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/daily_fortune.dart';
import 'dimension_arc.dart';

class FortuneScoreSection extends StatelessWidget {
  final DailyFortune fortune;

  const FortuneScoreSection({super.key, required this.fortune});

  static const _dimensionColors = [
    Color(0xFFFF6B8A), // love — pink
    Color(0xFF6C5CE7), // career — purple
    Color(0xFFFDCB6E), // wealth — gold
    Color(0xFF00CEC9), // study — teal
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        children: [
          // Overall score — big number
          Text(
            l10n.homeOverallScore,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${fortune.overallScore}',
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 56,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          // 4 dimension arcs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < fortune.dimensions.length && i < 4; i++)
                DimensionArc(
                  label: _dimensionLabel(fortune.dimensions[i].key, l10n),
                  score: fortune.dimensions[i].score,
                  color: _dimensionColors[i % _dimensionColors.length],
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Lucky elements row
          _buildLuckyRow(fortune.luckyElements, l10n),
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

  Widget _buildLuckyRow(LuckyElements lucky, AppLocalizations l10n) {
    final items = [
      (l10n.homeLuckyColor, lucky.color),
      (l10n.homeLuckyNumber, '${lucky.number}'),
      (l10n.homeLuckyFlower, lucky.flower),
      (l10n.homeLuckyStone, lucky.stone),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: CosmicColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.$1,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.$2,
                style: const TextStyle(
                  color: CosmicColors.secondaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
