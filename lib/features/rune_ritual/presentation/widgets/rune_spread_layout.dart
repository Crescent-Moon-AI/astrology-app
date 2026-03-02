import 'package:flutter/material.dart';

import '../../domain/models/rune_card.dart';
import 'rune_stone_3d.dart';

class RuneSpreadLayout extends StatelessWidget {
  final List<RuneDefinition> runes;
  final int revealIndex;

  const RuneSpreadLayout({
    super.key,
    required this.runes,
    required this.revealIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < runes.length; i++)
            RuneStone3D(
              rune: runes[i],
              showFace: i < revealIndex,
              size: runes.length > 3 ? 64 : 80,
            ),
        ],
      ),
    );
  }
}
