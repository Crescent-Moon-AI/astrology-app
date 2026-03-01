import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/tarot_card.dart';

class TarotCardFace extends StatelessWidget {
  final TarotCard card;
  final double width;
  final double height;

  const TarotCardFace({
    super.key,
    required this.card,
    this.width = 120,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isReversed = card.isReversed;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _arcanaColor.withValues(alpha: 0.8),
            _arcanaColor.withValues(alpha: 0.4),
            CosmicColors.background,
          ],
        ),
        border: Border.all(
          color: CosmicColors.secondary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.secondary.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card number
            Text(
              _romanNumeral,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),

            // Suit/element icon
            Text(
              _suitIcon,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 4),

            // Card name
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Chinese name
            if (card.nameZH.isNotEmpty)
              Text(
                card.nameZH,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
            const SizedBox(height: 6),

            // Orientation indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isReversed ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 12,
                  color: isReversed ? CosmicColors.error : CosmicColors.success,
                ),
                const SizedBox(width: 2),
                Text(
                  isReversed ? 'Reversed' : 'Upright',
                  style: TextStyle(
                    color: isReversed ? CosmicColors.error : CosmicColors.success,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Keywords (show up to 2)
            ...card.activeKeywords.take(2).map((kw) => Text(
                  kw,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }

  Color get _arcanaColor {
    if (card.arcana == 'major') return const Color(0xFF4A1A7A);
    return switch (card.suit) {
      'wands' => const Color(0xFFB85C1A),
      'cups' => const Color(0xFF1A5CB8),
      'swords' => const Color(0xFF5C5C5C),
      'pentacles' => const Color(0xFF2D7A2D),
      _ => const Color(0xFF4A1A7A),
    };
  }

  String get _romanNumeral {
    const numerals = [
      '', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX',
      'XXI',
    ];
    if (card.number >= 0 && card.number < numerals.length) {
      return numerals[card.number];
    }
    return card.number.toString();
  }

  String get _suitIcon {
    if (card.arcana == 'major') return '\u2605'; // star
    return switch (card.suit) {
      'wands' => '\u2642', // fire/wands
      'cups' => '\u2615', // cups
      'swords' => '\u2694', // swords
      'pentacles' => '\u2B50', // pentacles
      _ => '\u2726',
    };
  }
}
