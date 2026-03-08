import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class ExploreMoreSection extends StatelessWidget {
  const ExploreMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with "see all" link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.homeExploreMore,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/insight'),
                child: Text(
                  isZh ? '查看全部 >' : 'See All >',
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildExploreCard(
            isZh ? '全面了解自己' : 'Know Yourself',
            isZh ? '探索你未被发现的天赋' : 'Explore your hidden talents',
            () => context.push('/charts'),
          ),
          const SizedBox(height: 8),
          _buildExploreCard(
            isZh ? '了解你们的关系' : 'Your Relationship',
            isZh ? '月见 · 关系深度解读报告' : 'Deep relationship analysis',
            () => context.push('/charts/synastry'),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          color: CosmicColors.textTertiary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
