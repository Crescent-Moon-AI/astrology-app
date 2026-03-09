import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  int _selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title bar with icons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.insightTitle,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: CosmicColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: CosmicColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Quote section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.insightQuote,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.insightQuoteAuthor,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chart type chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildChip(0, l10n.insightMyChart, Icons.edit_outlined),
                      const SizedBox(width: 12),
                      _buildChip(
                        1,
                        l10n.insightSynastry,
                        Icons.compare_arrows_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Deep explore section
                _buildSectionHeader(
                  isZh ? '深度探索' : 'Deep Explore',
                  isZh ? '查看全部' : 'See All',
                  () {},
                ),
                const SizedBox(height: 12),
                _buildExploreCard(
                  isZh ? '全面了解自己' : 'Know Yourself',
                  isZh ? '探索你未被发现的天赋' : 'Explore your hidden talents',
                  Icons.auto_awesome_outlined,
                  () => context.push('/charts'),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '探索TA的世界' : 'Explore Their World',
                  isZh ? '读懂 TA 内心的"读心术"' : 'Read their inner world',
                  Icons.people_outline,
                  () => context.push('/charts/synastry'),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '了解你们的关系' : 'Understand Your Relationship',
                  isZh ? '星见 · 关系深度解读报告' : 'Deep relationship analysis',
                  Icons.favorite_outline,
                  () => context.push('/charts/synastry'),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '2026年度趋势报告' : '2026 Annual Trends',
                  isZh ? '掌握先机，让 2026年"开挂"' : 'Get ahead in 2026',
                  Icons.trending_up,
                  () {},
                ),

                const SizedBox(height: 24),

                // Explore more section
                _buildSectionHeader(
                  isZh ? '探索更多' : 'Explore More',
                  isZh ? '查看全部' : 'See All',
                  () {},
                ),
                const SizedBox(height: 12),
                _buildExploreCard(
                  isZh ? '灵魂伴侣' : 'Soul Mate',
                  isZh ? '查看你的灵魂伴侣' : 'Find your soul mate',
                  Icons.favorite,
                  () {},
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(int index, String label, IconData icon) {
    final isSelected = _selectedChip == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChip = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CosmicColors.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? CosmicColors.borderGlow
                : CosmicColors.textTertiary.withAlpha(77),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? CosmicColors.textPrimary
                  : CosmicColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? CosmicColors.textPrimary
                    : CosmicColors.textTertiary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
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
                        const Icon(
                          Icons.chevron_right,
                          color: CosmicColors.textTertiary,
                          size: 18,
                        ),
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
      ),
    );
  }
}
