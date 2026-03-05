import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/aspect_data.dart';

/// Colored dot indicating the nature of an aspect.
class AspectNatureDot extends StatelessWidget {
  final AspectNature nature;

  const AspectNatureDot({super.key, required this.nature});

  Color get _color {
    switch (nature) {
      case AspectNature.harmonious:
        return CosmicColors.success;
      case AspectNature.tense:
        return CosmicColors.error;
      case AspectNature.neutral:
        return CosmicColors.primaryLight;
      case AspectNature.minor:
        return CosmicColors.textTertiary;
      case AspectNature.creative:
        return CosmicColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
      ),
    );
  }
}
