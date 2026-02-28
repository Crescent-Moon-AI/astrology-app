import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../providers/social_providers.dart';
import '../widgets/friend_card.dart';

class FriendListPage extends ConsumerWidget {
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.friendsTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(friendsProvider);
        },
        child: friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) {
              return _EmptyState(l10n: l10n);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('addFriend'),
        tooltip: l10n.addFriend,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Icon(
          Icons.people_outline,
          size: 80,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.addFriend,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
