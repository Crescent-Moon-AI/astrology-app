import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/cosmic_colors.dart';

/// A frosted-glass card with backdrop blur, semi-transparent background,
/// and a subtle border glow.
class CosmicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  const CosmicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CosmicColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: CosmicColors.borderGlow,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A6C5CE7), // primary @ 10%
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
