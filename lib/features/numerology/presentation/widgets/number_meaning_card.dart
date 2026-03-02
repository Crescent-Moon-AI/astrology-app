import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/numerology_result.dart';

class NumberMeaningCard extends StatelessWidget {
  final NumerologyResult result;

  const NumberMeaningCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final meaning = isZh ? result.meaningZh : result.meaning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: CosmicColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        children: [
          if (result.isMasterNumber)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: CosmicColors.secondary.withAlpha(38),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CosmicColors.secondary.withAlpha(77)),
              ),
              child: Text(
                isZh ? '大师数字' : 'Master Number',
                style: const TextStyle(
                  color: CosmicColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            meaning,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
