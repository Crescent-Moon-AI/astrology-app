import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class HexagramLineWidget extends StatelessWidget {
  final bool isYang;
  final bool isMoving;
  final double width;
  final double height;

  const HexagramLineWidget({
    super.key,
    required this.isYang,
    this.isMoving = false,
    this.width = 120,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMoving ? CosmicColors.secondary : CosmicColors.textPrimary;

    if (isYang) {
      // Solid line (yang)
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
    }

    // Broken line (yin) — two segments with gap
    final segmentWidth = (width - height * 2) / 2;
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          Container(
            width: segmentWidth,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          SizedBox(width: height * 2),
          Container(
            width: segmentWidth,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ],
      ),
    );
  }
}
