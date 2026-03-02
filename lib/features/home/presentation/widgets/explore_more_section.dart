import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class ExploreMoreSection extends StatelessWidget {
  const ExploreMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeExploreMore,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            icon: Icons.auto_graph_rounded,
            title: l10n.insightDeepExplore,
            subtitle: l10n.insightComingSoon,
            gradient: [CosmicColors.primary, const Color(0xFF0984E3)],
            onTap: () => context.go('/insight'),
          ),
          const SizedBox(height: 8),
          _buildReportCard(
            context,
            icon: Icons.style_rounded,
            title: l10n.divinationHubTitle,
            subtitle: l10n.divinationHubSubtitle,
            gradient: [const Color(0xFFE17055), const Color(0xFFFDCB6E)],
            onTap: () => context.push('/divination'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradient[0].withAlpha(38), gradient[1].withAlpha(13)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gradient[0].withAlpha(26)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: gradient[0].withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: gradient[0], size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: CosmicColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
