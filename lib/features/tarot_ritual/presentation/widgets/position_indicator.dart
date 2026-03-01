import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class PositionIndicator extends StatelessWidget {
  final String label;
  final bool isRevealed;
  final bool isActive;

  const PositionIndicator({
    super.key,
    required this.label,
    this.isRevealed = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? CosmicColors.secondary.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: CosmicColors.secondary, width: 1)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isRevealed
              ? CosmicColors.secondary
              : CosmicColors.textTertiary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
