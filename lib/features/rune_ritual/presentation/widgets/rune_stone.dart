import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/rune_card.dart';

class RuneStone extends StatelessWidget {
  final RuneDefinition rune;
  final double size;

  const RuneStone({super.key, required this.rune, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Container(
      width: size,
      height: size * 1.2,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1A4E), Color(0xFF1A0A3E)],
        ),
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(
          color: CosmicColors.primaryLight.withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primary.withAlpha(38),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rune.symbol,
            style: TextStyle(
              fontSize: size * 0.4,
              color: CosmicColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isZh ? rune.nameZh : rune.name,
            style: TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: size * 0.12,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
