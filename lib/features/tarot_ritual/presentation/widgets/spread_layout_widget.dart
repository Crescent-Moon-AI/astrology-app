import 'package:flutter/material.dart';

import '../../domain/models/spread_type.dart';
import '../../domain/models/tarot_card.dart';
import 'position_indicator.dart';
import 'tarot_card_back.dart';
import 'tarot_card_face.dart';

class SpreadLayoutWidget extends StatelessWidget {
  final SpreadType spreadType;
  final List<ResolvedCard> cards;
  final List<String> positionLabels;
  final int revealedCount;

  const SpreadLayoutWidget({
    super.key,
    required this.spreadType,
    required this.cards,
    required this.positionLabels,
    required this.revealedCount,
  });

  @override
  Widget build(BuildContext context) {
    return switch (spreadType) {
      SpreadType.single => _buildSingleLayout(context),
      SpreadType.threeCard => _buildThreeCardLayout(context),
      SpreadType.loveSpread => _buildLoveSpreadLayout(context),
      SpreadType.celticCross => _buildCelticCrossLayout(context),
    };
  }

  Widget _buildSingleLayout(BuildContext context) {
    return Center(
      child: _buildCardSlot(context, 0),
    );
  }

  Widget _buildThreeCardLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardSlot(context, 0),
        const SizedBox(width: 12),
        _buildCardSlot(context, 1),
        const SizedBox(width: 12),
        _buildCardSlot(context, 2),
      ],
    );
  }

  Widget _buildLoveSpreadLayout(BuildContext context) {
    // Cross pattern: 2-1-2
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row (2 cards)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardSlot(context, 0, cardWidth: 90, cardHeight: 150),
            const SizedBox(width: 12),
            _buildCardSlot(context, 1, cardWidth: 90, cardHeight: 150),
          ],
        ),
        const SizedBox(height: 12),
        // Middle (1 card)
        _buildCardSlot(context, 2, cardWidth: 90, cardHeight: 150),
        const SizedBox(height: 12),
        // Bottom row (2 cards)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardSlot(context, 3, cardWidth: 90, cardHeight: 150),
            const SizedBox(width: 12),
            _buildCardSlot(context, 4, cardWidth: 90, cardHeight: 150),
          ],
        ),
      ],
    );
  }

  Widget _buildCelticCrossLayout(BuildContext context) {
    const cw = 70.0;
    const ch = 116.0;

    return SizedBox(
      width: 360,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Position 0: Center (Significator)
          Positioned(
            left: 80,
            top: 140,
            child: _buildCardSlot(context, 0, cardWidth: cw, cardHeight: ch),
          ),
          // Position 1: Crossing card (rotated 90 degrees)
          Positioned(
            left: 80,
            top: 140,
            child: Transform.rotate(
              angle: 1.5708, // 90 degrees
              child: _buildCardSlot(context, 1,
                  cardWidth: cw, cardHeight: ch),
            ),
          ),
          // Position 2: Above (Crown)
          Positioned(
            left: 80,
            top: 10,
            child: _buildCardSlot(context, 2, cardWidth: cw, cardHeight: ch),
          ),
          // Position 3: Below (Base)
          Positioned(
            left: 80,
            top: 270,
            child: _buildCardSlot(context, 3, cardWidth: cw, cardHeight: ch),
          ),
          // Position 4: Left (Past)
          Positioned(
            left: 0,
            top: 140,
            child: _buildCardSlot(context, 4, cardWidth: cw, cardHeight: ch),
          ),
          // Position 5: Right (Future)
          Positioned(
            left: 160,
            top: 140,
            child: _buildCardSlot(context, 5, cardWidth: cw, cardHeight: ch),
          ),
          // Staff positions (right column, bottom to top)
          // Position 6
          Positioned(
            right: 10,
            bottom: 0,
            child: _buildCardSlot(context, 6, cardWidth: cw, cardHeight: ch),
          ),
          // Position 7
          Positioned(
            right: 10,
            bottom: 126,
            child: _buildCardSlot(context, 7, cardWidth: cw, cardHeight: ch),
          ),
          // Position 8
          Positioned(
            right: 10,
            top: 126,
            child: _buildCardSlot(context, 8, cardWidth: cw, cardHeight: ch),
          ),
          // Position 9
          Positioned(
            right: 10,
            top: 0,
            child: _buildCardSlot(context, 9, cardWidth: cw, cardHeight: ch),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSlot(
    BuildContext context,
    int index, {
    double cardWidth = 100,
    double cardHeight = 166,
  }) {
    final isRevealed = index < revealedCount && index < cards.length;
    final label = index < positionLabels.length ? positionLabels[index] : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRevealed)
          TarotCardFace(
            card: cards[index].card,
            width: cardWidth,
            height: cardHeight,
          )
        else
          TarotCardBack(
            width: cardWidth,
            height: cardHeight,
          ),
        const SizedBox(height: 4),
        PositionIndicator(
          label: label,
          isRevealed: isRevealed,
        ),
      ],
    );
  }
}
