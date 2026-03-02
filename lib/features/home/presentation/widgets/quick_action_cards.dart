import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class QuickActionCards extends StatelessWidget {
  const QuickActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final actions = [
      _QuickAction(
        icon: Icons.question_answer_rounded,
        label: l10n.homeQuickConsult,
        gradient: [CosmicColors.primary, CosmicColors.primaryLight],
        onTap: () => context.go('/consult'),
      ),
      _QuickAction(
        icon: Icons.style_rounded,
        label: l10n.homeQuickTarot,
        gradient: [const Color(0xFFE17055), const Color(0xFFFDCB6E)],
        onTap: () => context.push('/tarot'),
      ),
      _QuickAction(
        icon: Icons.camera_alt_rounded,
        label: l10n.homeQuickPhoto,
        gradient: [const Color(0xFF00CEC9), const Color(0xFF55EFC4)],
        onTap: () {}, // placeholder
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: actions
            .map(
              (a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildCard(context, a),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              action.gradient[0].withAlpha(51),
              action.gradient[1].withAlpha(26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: action.gradient[0].withAlpha(38)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, color: action.gradient[0], size: 28),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
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
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}
