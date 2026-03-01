import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class SectionRevealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SectionRevealButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: CosmicColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primary.withAlpha(77), // 30%
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward,
          color: CosmicColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}
