import 'package:flutter/material.dart';

import '../../domain/models/coin_toss.dart';
import 'hexagram_line.dart';

class HexagramBuilder extends StatelessWidget {
  final List<CoinToss> tosses;
  final bool animate;

  const HexagramBuilder({
    super.key,
    required this.tosses,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    // Build lines from bottom (1) to top (6)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = tosses.length - 1; i >= 0; i--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: animate
                ? AnimatedSlide(
                    offset: Offset.zero,
                    duration: Duration(milliseconds: 300 + i * 100),
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300 + i * 100),
                      child: HexagramLineWidget(
                        isYang: tosses[i].isYang,
                        isMoving: tosses[i].isMoving,
                      ),
                    ),
                  )
                : HexagramLineWidget(
                    isYang: tosses[i].isYang,
                    isMoving: tosses[i].isMoving,
                  ),
          ),
      ],
    );
  }
}
