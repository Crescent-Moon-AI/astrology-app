import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/hexagram.dart';
import 'hexagram_line.dart';

class HexagramSymbol extends StatelessWidget {
  final Hexagram hexagram;

  const HexagramSymbol({super.key, required this.hexagram});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Unicode symbol
        Text(
          hexagram.symbol,
          style: const TextStyle(fontSize: 48, color: CosmicColors.secondary),
        ),
        const SizedBox(height: 8),
        // Name
        Text(
          isZh ? hexagram.nameZh : hexagram.name,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '#${hexagram.number}',
          style: const TextStyle(
            color: CosmicColors.textTertiary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        // Lines
        if (hexagram.lines.isNotEmpty)
          Column(
            children: [
              for (var i = hexagram.lines.length - 1; i >= 0; i--)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: HexagramLineWidget(
                    isYang: hexagram.lines[i].isYang,
                    isMoving: hexagram.lines[i].isMoving,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
