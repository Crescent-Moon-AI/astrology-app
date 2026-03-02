import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/lenormand_card.dart';

class LenormandCombination extends StatelessWidget {
  final LenormandCard cardA;
  final LenormandCard cardB;
  final String meaning;

  const LenormandCombination({
    super.key,
    required this.cardA,
    required this.cardB,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isZh ? cardA.nameZh : cardA.name,
                style: const TextStyle(
                  color: CosmicColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.add,
                  color: CosmicColors.textTertiary,
                  size: 16,
                ),
              ),
              Text(
                isZh ? cardB.nameZh : cardB.name,
                style: const TextStyle(
                  color: CosmicColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaning,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
