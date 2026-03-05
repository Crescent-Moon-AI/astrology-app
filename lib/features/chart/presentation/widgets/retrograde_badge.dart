import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// Small "Rx" badge indicating a retrograde planet.
class RetrogradeBadge extends StatelessWidget {
  const RetrogradeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Rx',
      style: TextStyle(
        color: CosmicColors.error,
        fontSize: 10,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
