import 'package:flutter/material.dart';

import '../../../iching_ritual/presentation/widgets/hexagram_line.dart';

class TrigramBuilderWidget extends StatelessWidget {
  final int trigramNumber; // 1-8 (Qian through Dui)
  final double lineWidth;

  const TrigramBuilderWidget({
    super.key,
    required this.trigramNumber,
    this.lineWidth = 60,
  });

  @override
  Widget build(BuildContext context) {
    // Map trigram number to line patterns (top to bottom)
    final lines = _getTrigramLines(trigramNumber);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < lines.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: HexagramLineWidget(
              isYang: lines[i],
              width: lineWidth,
              height: 6,
            ),
          ),
      ],
    );
  }

  List<bool> _getTrigramLines(int number) {
    // Standard trigram line patterns (top to bottom)
    return switch (number) {
      1 => [true, true, true], // Qian (Heaven)
      2 => [false, false, false], // Kun (Earth)
      3 => [false, false, true], // Zhen (Thunder)
      4 => [true, true, false], // Xun (Wind)
      5 => [false, true, false], // Kan (Water)
      6 => [true, false, true], // Li (Fire)
      7 => [true, false, false], // Gen (Mountain)
      8 => [false, true, true], // Dui (Lake)
      _ => [true, true, true],
    };
  }
}
