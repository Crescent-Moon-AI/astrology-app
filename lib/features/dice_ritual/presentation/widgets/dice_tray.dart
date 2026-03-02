import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class DiceTray extends StatelessWidget {
  final Widget child;

  const DiceTray({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow, width: 1),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primary.withAlpha(26),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
