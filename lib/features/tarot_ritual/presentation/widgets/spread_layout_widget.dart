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
    final screenW = MediaQuery.of(context).size.width;
    final cw = screenW * 0.40;
    final ch = cw / 0.6;
    return Center(
      child: _buildCardSlot(context, 0, cardWidth: cw, cardHeight: ch),
    );
  }

  Widget _buildThreeCardLayout(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cw = screenW * 0.27;
    final ch = cw / 0.6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardSlot(context, 0, cardWidth: cw, cardHeight: ch),
        const SizedBox(width: 10),
        _buildCardSlot(context, 1, cardWidth: cw, cardHeight: ch),
        const SizedBox(width: 10),
        _buildCardSlot(context, 2, cardWidth: cw, cardHeight: ch),
      ],
    );
  }

  Widget _buildLoveSpreadLayout(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cw = screenW * 0.22;
    final ch = cw / 0.6;
    // Cross pattern: 2-1-2
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardSlot(context, 0, cardWidth: cw, cardHeight: ch),
            const SizedBox(width: 10),
            _buildCardSlot(context, 1, cardWidth: cw, cardHeight: ch),
          ],
        ),
        const SizedBox(height: 10),
        _buildCardSlot(context, 2, cardWidth: cw, cardHeight: ch),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardSlot(context, 3, cardWidth: cw, cardHeight: ch),
            const SizedBox(width: 10),
            _buildCardSlot(context, 4, cardWidth: cw, cardHeight: ch),
          ],
        ),
      ],
    );
  }

  Widget _buildCelticCrossLayout(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cw = screenW * 0.17;
    final ch = cw / 0.6;
    final gap = cw * 0.12;

    // Proportional layout
    final crossW = cw * 3 + gap * 2;
    final crossH = ch * 3 + gap * 2;
    final staffX = crossW + gap * 2;
    final totalW = staffX + cw;
    final totalH = crossH > ch * 4 + gap * 3 ? crossH : ch * 4 + gap * 3;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Position 0: Center (Significator)
          Positioned(
            left: cw + gap,
            top: ch + gap,
            child: _buildCardSlot(context, 0, cardWidth: cw, cardHeight: ch),
          ),
          // Position 1: Crossing card (rotated 90°)
          Positioned(
            left: cw + gap,
            top: ch + gap,
            child: Transform.rotate(
              angle: 1.5708,
              child: _buildCardSlot(context, 1, cardWidth: cw, cardHeight: ch),
            ),
          ),
          // Position 2: Above (Crown)
          Positioned(
            left: cw + gap,
            top: 0,
            child: _buildCardSlot(context, 2, cardWidth: cw, cardHeight: ch),
          ),
          // Position 3: Below (Base)
          Positioned(
            left: cw + gap,
            top: (ch + gap) * 2,
            child: _buildCardSlot(context, 3, cardWidth: cw, cardHeight: ch),
          ),
          // Position 4: Left (Past)
          Positioned(
            left: 0,
            top: ch + gap,
            child: _buildCardSlot(context, 4, cardWidth: cw, cardHeight: ch),
          ),
          // Position 5: Right (Future)
          Positioned(
            left: (cw + gap) * 2,
            top: ch + gap,
            child: _buildCardSlot(context, 5, cardWidth: cw, cardHeight: ch),
          ),
          // Staff column (right side, bottom to top)
          Positioned(
            left: staffX,
            bottom: 0,
            child: _buildCardSlot(context, 6, cardWidth: cw, cardHeight: ch),
          ),
          Positioned(
            left: staffX,
            bottom: ch + gap,
            child: _buildCardSlot(context, 7, cardWidth: cw, cardHeight: ch),
          ),
          Positioned(
            left: staffX,
            top: ch + gap,
            child: _buildCardSlot(context, 8, cardWidth: cw, cardHeight: ch),
          ),
          Positioned(
            left: staffX,
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
    required double cardWidth,
    required double cardHeight,
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
          TarotCardBack(width: cardWidth, height: cardHeight),
        const SizedBox(height: 4),
        PositionIndicator(label: label, isRevealed: isRevealed),
      ],
    );
  }
}
