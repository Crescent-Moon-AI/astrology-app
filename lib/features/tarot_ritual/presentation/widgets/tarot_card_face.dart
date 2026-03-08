import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/utils/card_asset_paths.dart';
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
    final hasImageKey = card.imageKey.isNotEmpty;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.tarotGold, width: 2),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.tarotGold.withAlpha(51),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: hasImageKey ? _buildImageCard(isZh) : _buildProceduralCard(isZh),
      ),
    );
  }

  /// Image-based card face with RWS artwork.
  Widget _buildImageCard(bool isZh) {
    final assetPath = CardAssetPaths.tarotAssetPath(card.imageKey);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Card artwork — reversed cards rotate 180°
        Transform.rotate(
          angle: card.isReversed ? 3.14159 : 0,
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            cacheWidth: 300,
            errorBuilder: (_, __, ___) => _buildProceduralCard(isZh),
          ),
        ),
        // Semi-transparent overlay at bottom for name + orientation
        // Tall gradient covers the PNG's embedded text for a clean layered look
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 30, 6, 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(230),
                  Colors.black,
                ],
                stops: const [0.0, 0.3, 0.7],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.nameZH.isNotEmpty ? card.nameZH : _displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      card.isReversed
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 10,
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
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Fallback procedural card (emoji + text, original design).
  Widget _buildProceduralCard(bool isZh) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _arcanaColor.withAlpha(204),
            _arcanaColor.withAlpha(128),
            CosmicColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
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

            // Suit/element icon
            Text(_suitIcon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 6),

            // Chinese name
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
              _displayName,
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
                  color: CosmicColors.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CosmicColors.primary.withAlpha(77)),
                ),
                child: Text(
                  _elementLabel(isZh),
                  style: const TextStyle(
                    color: CosmicColors.primaryLight,
                    fontSize: 9,
                  ),
                ),
              ),

            // Active keywords (max 2)
            if (card.activeKeywords.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                card.localizedKeywords(isZh).take(2).join(' · '),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),

            // Orientation indicator
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
    if (card.arcana == 'major') return '\u2727';
    return switch (card.suit) {
      'wands' => '\uD83D\uDD25',
      'cups' => '\uD83C\uDFC6',
      'swords' => '\u2694\uFE0F',
      'pentacles' => '\u2B50',
      _ => '\u2727',
    };
  }

  String get _displayName {
    if (!card.name.contains('_')) return card.name;
    return card.name
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
