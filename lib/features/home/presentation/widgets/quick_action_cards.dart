import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// Quick action buttons matching real app: horizontally scrollable rectangular
/// cards with text on top-left and icon on bottom-right.
class QuickActionCards extends StatelessWidget {
  const QuickActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final actions = [
      _QuickAction(
        icon: Icons.question_answer_rounded,
        label: l10n.homeQuickConsult,
        onTap: () => context.push('/chat'),
      ),
      _QuickAction(
        icon: Icons.style_rounded,
        label: l10n.homeQuickTarot,
        onTap: () => context.push('/tarot'),
      ),
      _QuickAction(
        icon: Icons.camera_alt_rounded,
        label: l10n.homeQuickPhoto,
        onTap: () => context.push('/photo-analysis'),
      ),
      _QuickAction(
        icon: Icons.auto_awesome_rounded,
        label: l10n.homeQuickChartConsult,
        onTap: () => context.push('/chat?scenario_id=chart-consultation'),
      ),
      _QuickAction(
        icon: Icons.stars_rounded,
        label: l10n.homeQuickMyChart,
        onTap: () => context.push('/charts'),
      ),
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => _buildCard(context, actions[index]),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _QuickAction action) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Each card takes roughly 1/3 of screen width minus padding, so 3 cards
    // are visible at once and the user can scroll to reveal the rest.
    final cardWidth = (screenWidth - 48) / 3;

    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              action.label,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                action.icon,
                color: CosmicColors.textTertiary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
