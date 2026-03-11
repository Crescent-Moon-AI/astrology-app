import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../chart/domain/models/birth_data.dart';
import '../../../social/domain/models/friend_profile.dart';
import '../../../social/presentation/providers/social_providers.dart';
import 'relationship_report_page.dart';

class InsightPage extends ConsumerStatefulWidget {
  const InsightPage({super.key});

  @override
  ConsumerState<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends ConsumerState<InsightPage> {
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
                  isZh ? '全面了解你自己' : 'Know Yourself',
                  isZh ? '探索你未被发现的天赋' : 'Explore your hidden talents',
                  Icons.auto_awesome_outlined,
                  () => context.push(
                    '/insight/report',
                    extra: RelationshipReportArgs(
                      reportProductId: 'report_self_exploration',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '探索TA的世界' : 'Explore Their World',
                  isZh ? '读懂 TA 内心的"读心术"' : 'Read their inner world',
                  Icons.people_outline,
                  () => _showFriendPicker(
                    context,
                    isZh,
                    mode: _FriendPickerMode.reportOtherExploration,
                  ),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '了解你们的关系' : 'Understand Your Relationship',
                  isZh ? '星见 · 关系深度解读报告' : 'Deep relationship analysis',
                  Icons.favorite_outline,
                  () => _showFriendPicker(
                    context,
                    isZh,
                    mode: _FriendPickerMode.reportRelationship,
                  ),
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  isZh ? '2026年度趋势报告' : '2026 Annual Trends',
                  isZh ? '掌握先机，让 2026年"开挂"' : 'Get ahead in 2026',
                  Icons.trending_up,
                  () => context.pushNamed(
                    'chat',
                    queryParameters: {
                      'prefill_message': isZh
                          ? '请帮我生成2026年度趋势报告，基于我的星盘分析今年的运势走向、重要时机和需要注意的方向'
                          : 'Please generate my 2026 annual trends report based on my birth chart',
                    },
                  ),
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
                  () => context.pushNamed(
                    'chat',
                    queryParameters: {
                      'prefill_message': isZh
                          ? '根据我的星盘，帮我分析我的灵魂伴侣特征：哪种星座与我最契合？在感情中我需要什么样的伴侣？'
                          : 'Based on my birth chart, analyze my soul mate characteristics: which signs are most compatible with me?',
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFriendPicker(
    BuildContext context,
    bool isZh, {
    required _FriendPickerMode mode,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CosmicColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: CosmicColors.borderGlow),
      ),
      builder: (ctx) => _FriendPickerSheet(
        isZh: isZh,
        mode: mode,
        onFriendSelected: (friend) {
          Navigator.of(ctx).pop();
          final birthData = BirthData(
            name: friend.name,
            birthDate: friend.birthDate,
            birthTime: friend.birthTime ?? '12:00',
            latitude: friend.latitude,
            longitude: friend.longitude,
            timezone: double.tryParse(friend.timezone) ?? 8.0,
            location: friend.birthLocationName,
          );
          if (mode == _FriendPickerMode.natalChart) {
            context.push('/charts', extra: birthData);
          } else if (mode == _FriendPickerMode.reportOtherExploration) {
            context.push(
              '/insight/report',
              extra: RelationshipReportArgs(
                reportProductId: 'report_other_exploration',
                friendId: friend.id,
                friendName: friend.name,
              ),
            );
          } else {
            context.push(
              '/insight/report',
              extra: RelationshipReportArgs(
                reportProductId: 'report_relationship_exploration',
                friendId: friend.id,
                friendName: friend.name,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChip(int index, String label, IconData icon) {
    final isSelected = _selectedChip == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedChip = index);
        if (index == 0) {
          context.push('/charts');
        } else if (index == 1) {
          context.push('/charts/synastry');
        }
      },
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

enum _FriendPickerMode { natalChart, reportRelationship, reportOtherExploration }

class _FriendPickerSheet extends ConsumerWidget {
  final bool isZh;
  final _FriendPickerMode mode;
  final ValueChanged<FriendProfile> onFriendSelected;

  const _FriendPickerSheet({
    required this.isZh,
    required this.mode,
    required this.onFriendSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final title = mode == _FriendPickerMode.natalChart
        ? (isZh ? '选择要查看星盘的好友' : 'Select a friend to view chart')
        : mode == _FriendPickerMode.reportOtherExploration
            ? (isZh ? '选择好友档案' : 'Select a friend profile')
            : mode == _FriendPickerMode.reportRelationship
                ? (isZh ? '选择要生成关系报告的好友' : 'Select a friend for relationship report')
                : (isZh ? '选择要了解关系的好友' : 'Select a friend for relationship analysis');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: CosmicColors.textTertiary.withAlpha(80),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 48,
                      color: CosmicColors.textTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isZh ? '暂无好友档案，请先添加' : 'No friend profiles yet',
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: friends.length,
                itemBuilder: (ctx, i) {
                  final friend = friends[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: CosmicColors.primary.withAlpha(40),
                      child: Text(
                        friend.name.isNotEmpty
                            ? friend.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: CosmicColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      friend.name,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                    ),
                    subtitle: Text(
                      friend.birthDate +
                          (friend.birthTime != null
                              ? ' ${friend.birthTime}'
                              : ''),
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () => onFriendSelected(friend),
                  );
                },
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: CosmicColors.primary),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              isZh ? '加载失败' : 'Failed to load',
              style: const TextStyle(color: CosmicColors.error),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
