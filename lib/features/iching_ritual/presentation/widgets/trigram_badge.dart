import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/trigram.dart';

class TrigramBadge extends StatelessWidget {
  final Trigram trigram;

  const TrigramBadge({super.key, required this.trigram});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trigram.symbol,
            style: const TextStyle(fontSize: 20, color: CosmicColors.secondary),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isZh ? trigram.nameZh : trigram.name,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                trigram.element,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
