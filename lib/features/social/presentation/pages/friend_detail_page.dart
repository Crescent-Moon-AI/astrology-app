import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../providers/social_providers.dart';
import '../widgets/relationship_label_badge.dart';
import '../widgets/synastry_score_bars.dart';

class FriendDetailPage extends ConsumerWidget {
  final String friendId;

  const FriendDetailPage({
    super.key,
    required this.friendId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final detailAsync = ref.watch(friendDetailProvider(friendId));

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.when(
          data: (friend) => Text(
            friend.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: CosmicColors.textPrimary,
            ),
          ),
          loading: () => Text(
            l10n.friendsTitle,
            style: const TextStyle(color: CosmicColors.textPrimary),
          ),
          error: (_, __) => Text(
            l10n.friendsTitle,
            style: const TextStyle(color: CosmicColors.textPrimary),
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                _confirmDelete(context, ref, l10n, isZh);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline,
                        size: 20, color: CosmicColors.error),
                    const SizedBox(width: 8),
                    Text(
                      l10n.friendDelete,
                      style: const TextStyle(color: CosmicColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: detailAsync.when(
        data: (friend) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        CosmicColors.primary.withValues(alpha: 0.15),
                        CosmicColors.surfaceElevated,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: CosmicColors.borderGlow),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: CosmicColors.primaryGradient,
                        ),
                        child: Center(
                          child: Text(
                            friend.name.isNotEmpty
                                ? friend.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: CosmicColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    friend.name,
                                    style: const TextStyle(
                                      color: CosmicColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (friend.relationshipLabel.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  RelationshipLabelBadge(
                                    label: friend.relationshipLabel,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              friend.birthDate +
                                  (friend.birthTime != null
                                      ? ' ${friend.birthTime}'
                                      : ''),
                              style: const TextStyle(
                                color: CosmicColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            if (friend.birthLocationName.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                friend.birthLocationName,
                                style: const TextStyle(
                                  color: CosmicColors.textTertiary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Synastry scores
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 18, color: CosmicColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      isZh ? '合盘分析' : 'Synastry',
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CosmicColors.surfaceElevated,
                    border: Border.all(color: CosmicColors.borderGlow),
                  ),
                  child: SynastryScoreBars(
                    scores: const {
                      'overall': 72,
                      'emotional': 65,
                      'intellectual': 80,
                      'physical': 58,
                      'spiritual': 74,
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: CosmicColors.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: CosmicColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(
                                'chat',
                                queryParameters: {
                                  'scenario_id': 'synastry_reading',
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      color: CosmicColors.textPrimary,
                                      size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.askAiAboutThis,
                                    style: const TextStyle(
                                      color: CosmicColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.shareCard)),
                          );
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: Text(l10n.shareTitle),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CosmicColors.primaryLight,
                          side: const BorderSide(color: CosmicColors.borderGlow),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: BreathingLoader()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off,
                  size: 48, color: CosmicColors.textTertiary),
              const SizedBox(height: 12),
              Text(
                'Error: $error',
                style: const TextStyle(color: CosmicColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isZh,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CosmicColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CosmicColors.borderGlow),
        ),
        title: Text(
          l10n.friendDelete,
          style: const TextStyle(color: CosmicColors.textPrimary),
        ),
        content: Text(
          l10n.friendDeleteConfirm,
          style: const TextStyle(color: CosmicColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(isZh ? '取消' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.friendDelete,
              style: const TextStyle(color: CosmicColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final repo = ref.read(socialRepositoryProvider);
        await repo.deleteFriend(friendId);
        ref.invalidate(friendsProvider);
        if (context.mounted) {
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e')),
          );
        }
      }
    }
  }
}
