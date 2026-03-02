import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/lenormand_card.dart';

class LenormandCardFace extends StatelessWidget {
  final LenormandCard card;
  final double width;
  final double height;

  const LenormandCardFace({
    super.key,
    required this.card,
    this.width = 100,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1860), Color(0xFF1A0A3E)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CosmicColors.secondary.withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: CosmicColors.primary.withAlpha(38), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: CosmicColors.secondary.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${card.number}',
              style: const TextStyle(
                color: CosmicColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Icon placeholder
          Text(
            card.icon.isNotEmpty ? card.icon : '\u2B50', // star
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 6),
          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              isZh ? card.nameZh : card.name,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
