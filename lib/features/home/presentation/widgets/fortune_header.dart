import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/moon_phase_widget.dart';
import '../../domain/models/daily_fortune.dart';

class FortuneHeader extends StatelessWidget {
  final DailyFortune fortune;

  const FortuneHeader({super.key, required this.fortune});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Moon phase icon centered
          const Center(child: MoonPhaseWidget(size: 48)),
          const SizedBox(height: 12),
          // Fortune title — large poetic text, left-aligned like real app
          Text(
            fortune.title,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Advice + Avoid row
          Row(
            children: [
              _buildTag(
                l10n.homeFortuneAdvice,
                fortune.advice,
                CosmicColors.success,
              ),
              const SizedBox(width: 16),
              _buildTag(
                l10n.homeFortuneAvoid,
                fortune.avoid,
                CosmicColors.error,
              ),
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
