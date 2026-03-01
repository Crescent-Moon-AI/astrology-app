import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../providers/social_providers.dart';
import '../widgets/friend_card.dart';

class FriendListPage extends ConsumerWidget {
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.friendsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: CosmicColors.primary,
        backgroundColor: CosmicColors.surfaceElevated,
        onRefresh: () async {
          ref.invalidate(friendsProvider);
        },
        child: friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) {
              return _EmptyState(l10n: l10n, isZh: isZh);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
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
              },
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
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: CosmicColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.pushNamed('addFriend'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          tooltip: l10n.addFriend,
          child: const Icon(
            Icons.person_add,
            color: CosmicColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isZh;

  const _EmptyState({required this.l10n, required this.isZh});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            children: [
              const Text('\uD83C\uDF1F', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text(
                isZh ? '还没有好友' : 'No friends yet',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isZh
                    ? '添加好友，查看你们的星象关系'
                    : 'Add friends to see your astrological compatibility',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
