import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/utils/card_asset_paths.dart';
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CosmicColors.secondary.withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: CosmicColors.primary.withAlpha(38), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: card.number > 0
            ? _buildImageCard(isZh)
            : _buildProceduralCard(isZh),
      ),
    );
  }

  /// Image-based card face with Lenormand artwork.
  Widget _buildImageCard(bool isZh) {
    final assetPath = CardAssetPaths.lenormandAssetPath(card.number);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          assetPath,
          fit: BoxFit.cover,
          cacheWidth: 300,
          errorBuilder: (_, __, ___) => _buildProceduralCard(isZh),
        ),
        // Bottom overlay with card name + number
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 5),
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
                  '${card.number}',
                  style: const TextStyle(
                    color: CosmicColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
                Text(
                  isZh ? card.nameZh : card.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1860), Color(0xFF1A0A3E)],
        ),
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
            card.icon.isNotEmpty ? card.icon : '\u2B50',
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
