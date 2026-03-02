import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/moon_phase_widget.dart';
import '../../domain/models/daily_fortune.dart';

class FortuneHeader extends StatelessWidget {
  final DailyFortune fortune;

  const FortuneHeader({super.key, required this.fortune});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Moon phase icon
          const MoonPhaseWidget(size: 48),
          const SizedBox(height: 12),
          // Fortune title — poetic
          Text(
            fortune.title,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Advice + Avoid row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag('宜', fortune.advice, CosmicColors.success),
              const SizedBox(width: 16),
              _buildTag('忌', fortune.avoid, CosmicColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String prefix, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            prefix,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: CosmicColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
