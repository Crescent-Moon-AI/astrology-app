import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: const Color(0xFFD4AF37), width: 1)
            : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isRevealed
              ? const Color(0xFFD4AF37)
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
