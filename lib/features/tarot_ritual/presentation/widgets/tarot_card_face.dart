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
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _arcanaColor.withAlpha(204), // 80%
            _arcanaColor.withAlpha(128), // 50%
            CosmicColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: CosmicColors.secondary, width: 2),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.secondary.withAlpha(51), // 20%
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
            const SizedBox(height: 6),

            // Suit/element icon — larger
            Text(_suitIcon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 6),

            // Chinese name — prominent
            if (card.nameZH.isNotEmpty)
              Text(
                card.nameZH,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

            // English name
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Element tag pill
            if (card.element.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CosmicColors.primary.withAlpha(51), // 20%
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CosmicColors.primary.withAlpha(77), // 30%
                  ),
                ),
                child: Text(
                  _elementLabel(isZh),
                  style: const TextStyle(
                    color: CosmicColors.primaryLight,
                    fontSize: 9,
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // Orientation indicator — Chinese
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  card.isReversed ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 12,
                  color: card.isReversed
                      ? CosmicColors.error
                      : CosmicColors.success,
                ),
                const SizedBox(width: 2),
                Text(
                  card.isReversed
                      ? (isZh ? '\u9006\u4F4D' : 'Reversed')
                      : (isZh ? '\u6B63\u4F4D' : 'Upright'),
                  style: TextStyle(
                    color: card.isReversed
                        ? CosmicColors.error
                        : CosmicColors.success,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _elementLabel(bool isZh) {
    if (!isZh) return card.element;
    final zhMap = {
      'fire': '\u706B\u5143\u7D20',
      'water': '\u6C34\u5143\u7D20',
      'air': '\u98CE\u5143\u7D20',
      'earth': '\u571F\u5143\u7D20',
    };
    return zhMap[card.element.toLowerCase()] ?? card.element;
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
      '',
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
      'XIII',
      'XIV',
      'XV',
      'XVI',
      'XVII',
      'XVIII',
      'XIX',
      'XX',
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
