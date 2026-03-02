import 'package:flutter/material.dart';

import '../../domain/models/lenormand_card.dart';
import 'lenormand_card_face.dart';

class GrandTableauLayout extends StatelessWidget {
  final List<ResolvedLenormandCard> cards;

  const GrandTableauLayout({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    // 4 rows x 9 columns layout
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var row = 0; row < 4; row++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var col = 0; col < 9; col++)
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: _buildCell(row * 9 + col),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    if (index >= cards.length) {
      return const SizedBox(width: 36, height: 54);
    }

    return LenormandCardFace(card: cards[index].card, width: 36, height: 54);
  }
}
