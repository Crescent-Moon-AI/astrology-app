import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/models/expression.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../providers/social_providers.dart';
import '../widgets/friend_card.dart';

class FriendListPage extends ConsumerWidget {
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final friendsAsync = ref.watch(friendsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.chartArchivesTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background.withValues(alpha: 0.95),
        centerTitle: true,
        elevation: 0,
      ),
      body: StarfieldBackground(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: CosmicColors.primary,
                backgroundColor: CosmicColors.surfaceElevated,
                onRefresh: () async {
                  ref.invalidate(friendsProvider);
                  ref.invalidate(userProfileProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    // -- "你的星盘" section --
                    _SectionHeader(title: l10n.chartArchivesMyChart),
                    const SizedBox(height: 8),
                    profileAsync.when(
                      data: (profile) {
                        final core = profile.core;
                        final place = profile.currentBirthPlace;
                        final hasBirthData = core.birthDate != null;

                        String subtitle = l10n.chartArchivesNotSet;
                        if (hasBirthData) {
                          final parts = <String>[core.birthDate!];
                          if (core.birthTime != null) {
                            parts.add(core.birthTime!);
                          }
                          if (place?.normalizedName != null) {
                            parts.add(place!.normalizedName!);
                          }
                          subtitle = parts.join(' ');
                        }

                        return _MyChartCard(
                          username: user?.username ?? user?.phone ?? '',
                          subtitle: subtitle,
                          selfLabel: l10n.chartArchivesSelf,
                          onEdit: () => context.push('/settings/birth-data'),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: BreathingLoader(),
                        ),
                      ),
                      error: (_, __) => _MyChartCard(
                        username: user?.username ?? user?.phone ?? '',
                        subtitle: l10n.errorLoadFailed,
                        selfLabel: l10n.chartArchivesSelf,
                        onEdit: () => context.push('/settings/birth-data'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // -- "Ta的星盘" section --
                    _SectionHeader(title: l10n.chartArchivesFriendChart),
                    const SizedBox(height: 8),
                    friendsAsync.when(
                      data: (friends) {
                        if (friends.isEmpty) {
                          return _FriendEmptyState(
                            label: l10n.chartArchivesNoData,
                          );
                        }
                        return Column(
                          children: friends.map((friend) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FriendCard(
                                friend: friend,
                                onTap: () => context.pushNamed(
                                  'friendDetail',
                                  pathParameters: {'id': friend.id},
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: BreathingLoader(),
                        ),
                      ),
                      error: (error, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Error: $error',
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Bottom "添加星盘档案" button --
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: CosmicColors.primaryGradient,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: CosmicColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      onPressed: () => context.pushNamed('addFriend'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        l10n.chartArchivesAddChart,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header with a left accent bar, e.g. "| 你的星盘"
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: CosmicColors.primaryLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// User's own chart card — matches real device layout.
class _MyChartCard extends StatelessWidget {
  final String username;
  final String subtitle;
  final String selfLabel;
  final VoidCallback onEdit;

  const _MyChartCard({
    required this.username,
    required this.subtitle,
    required this.selfLabel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: CosmicColors.surfaceElevated,
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        children: [
          // Avatar
          const CharacterAvatar(
            expression: ExpressionId.greeting,
            size: CharacterAvatarSize.md,
          ),
          const SizedBox(width: 14),
          // Name + "本人" badge + birth info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        username,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: CosmicColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        selfLabel,
                        style: const TextStyle(
                          color: CosmicColors.primaryLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit button
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: CosmicColors.textSecondary,
              size: 20,
            ),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

/// Empty state for the "Ta的星盘" section — matches real device illustration style.
class _FriendEmptyState extends StatelessWidget {
  final String label;
  const _FriendEmptyState({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 56,
              color: CosmicColors.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
