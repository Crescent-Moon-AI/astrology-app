import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/cosmic_colors.dart';

/// A shimmer loading placeholder that replaces bare CircularProgressIndicator.
///
/// Shows animated rounded rectangles with a shimmer sweep effect.
class CosmicShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const CosmicShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    this.height = 80,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: CosmicColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: CosmicColors.shimmerHighlight,
        );
  }
}
