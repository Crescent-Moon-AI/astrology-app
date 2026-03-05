import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/models/expression.dart';

class ChartConsultTab extends ConsumerWidget {
  const ChartConsultTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final engine = ref.watch(astroEngineProvider);
    final isAvailable = engine.isAvailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CharacterAvatar(
            expression: ExpressionId.thinking,
            size: CharacterAvatarSize.lg,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.consultChartPrompt,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _ChartOptionCard(
                  icon: Icons.circle_outlined,
                  label: l10n.insightMyChart,
                  subtitle: isAvailable
                      ? l10n.chartLocalEngine
                      : l10n.insightComingSoon,
                  enabled: isAvailable,
                  onTap: isAvailable
                      ? () => context.push('/charts')
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ChartOptionCard(
                  icon: Icons.compare_arrows_rounded,
                  label: l10n.insightSynastry,
                  subtitle: isAvailable
                      ? l10n.chartLocalEngine
                      : l10n.insightComingSoon,
                  enabled: isAvailable,
                  onTap: isAvailable
                      ? () => context.push('/charts/synastry')
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _ChartOptionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: enabled
                  ? CosmicColors.primaryLight
                  : CosmicColors.textTertiary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: enabled
                    ? CosmicColors.textPrimary
                    : CosmicColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
