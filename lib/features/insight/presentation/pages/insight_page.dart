import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../chart/domain/models/birth_data.dart';
import '../../../settings/domain/models/user_profile.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
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

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  /// Check if birth data is set; if not, show a dialog and return false.
  bool _requireBirthData(UserProfile? profile) {
    final hasBirthDate = profile?.core.birthDate != null &&
        (profile!.core.birthDate?.isNotEmpty ?? false);
    if (!hasBirthDate) {
      _showBirthDataDialog();
      return false;
    }
    return true;
  }

  void _showBirthDataDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.insightBirthDataRequiredTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          l10n.insightBirthDataRequiredMsg,
          style: const TextStyle(
            color: CosmicColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.insightCancel,
              style: const TextStyle(color: CosmicColors.textTertiary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/settings/birth-data');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CosmicColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(l10n.insightGoToSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.asData?.value;

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
                        onPressed: () {
                          if (_requireBirthData(profile)) {
                            context.push('/friends/add');
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: CosmicColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () => context.push('/friends'),
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
                  l10n.insightDeepExplore,
                  l10n.insightSeeAll,
                  () {},
                ),
                const SizedBox(height: 12),
                _buildExploreCard(
                  l10n.insightKnowYourself,
                  l10n.insightKnowYourselfSub,
                  Icons.auto_awesome_outlined,
                  () {
                    if (!_requireBirthData(profile)) return;
                    context.push(
                      '/insight/report',
                      extra: RelationshipReportArgs(
                        reportProductId: 'report_self_exploration',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  l10n.insightExploreTarget,
                  l10n.insightReadMindSub,
                  Icons.people_outline,
                  () {
                    if (!_requireBirthData(profile)) return;
                    _showFriendPicker(
                      context,
                      mode: _FriendPickerMode.reportOtherExploration,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  l10n.insightUnderstandRelationship,
                  l10n.insightDeepAnalysisSub,
                  Icons.favorite_outline,
                  () {
                    if (!_requireBirthData(profile)) return;
                    _showFriendPicker(
                      context,
                      mode: _FriendPickerMode.reportRelationship,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildExploreCard(
                  l10n.insightAnnualTrends,
                  l10n.insightAnnualTrendsSub,
                  Icons.trending_up,
                  () {
                    if (!_requireBirthData(profile)) return;
                    context.pushNamed(
                      'chat',
                      queryParameters: {
                        'prefill_message': l10n.insightAnnualTrendsPrefill,
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Explore more section
                _buildSectionHeader(
                  l10n.insightExploreMore,
                  l10n.insightSeeAll,
                  () {},
                ),
                const SizedBox(height: 12),

                // Soul mate - special card matching 月见 style
                _buildSoulMateCard(profile),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFriendPicker(
    BuildContext context, {
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

  /// Soul mate card — styled to match 月见's visual design with gradient background.
  Widget _buildSoulMateCard(UserProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          if (!_requireBirthData(profile)) return;
          context.pushNamed('soulMate');
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF15161C), Color(0xFF000109)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withAlpha(33),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Top-left gradient blob
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF666957).withAlpha(179),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Right decorative area
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 176,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Background image representation with gradient
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0A0B12), Colors.transparent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      // Stars decoration
                      for (final pos in [
                        [0.15, 0.2, 5.0],
                        [0.6, 0.3, 3.5],
                        [0.4, 0.65, 7.0],
                        [0.82, 0.72, 4.5],
                        [0.28, 0.82, 3.5],
                      ])
                        Positioned(
                          left: pos[0] * 176,
                          top: pos[1] * 100,
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.white.withAlpha(80),
                            size: pos[2],
                          ),
                        ),
                      // Heart icon
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                CosmicColors.primary.withAlpha(70),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: CosmicColors.primaryLight,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Border overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withAlpha(33),
                      width: 1,
                    ),
                  ),
                ),
              ),
              // Text content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 52, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.insightSoulMate,
                          style: const TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(13),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                            size: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.insightFindSoulMate,
                      style: const TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 14,
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
  final _FriendPickerMode mode;
  final ValueChanged<FriendProfile> onFriendSelected;

  const _FriendPickerSheet({
    required this.mode,
    required this.onFriendSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final friendsAsync = ref.watch(friendsProvider);
    final title = mode == _FriendPickerMode.natalChart
        ? l10n.insightSelectFriendChart
        : mode == _FriendPickerMode.reportOtherExploration
            ? l10n.insightSelectFriendProfile
            : mode == _FriendPickerMode.reportRelationship
                ? l10n.insightSelectFriendReport
                : l10n.insightSelectFriendRelationship;

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
                      l10n.insightNoFriends,
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/friends/add');
                      },
                      icon: const Icon(Icons.person_add_outlined, size: 18),
                      label: Text(l10n.insightAddFriend),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CosmicColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
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
              l10n.insightLoadFailed,
              style: const TextStyle(color: CosmicColors.error),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
