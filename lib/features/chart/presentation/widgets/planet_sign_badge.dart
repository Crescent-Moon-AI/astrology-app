import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// Inline badge showing zodiac sign + degree, e.g. "♊ 23°54'".
class PlanetSignBadge extends StatelessWidget {
  final String signSymbol;
  final int degree;
  final int minute;

  const PlanetSignBadge({
    super.key,
    required this.signSymbol,
    required this.degree,
    required this.minute,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$signSymbol $degree\u00B0$minute\'',
      style: const TextStyle(
        color: CosmicColors.primaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    );
  }
}
