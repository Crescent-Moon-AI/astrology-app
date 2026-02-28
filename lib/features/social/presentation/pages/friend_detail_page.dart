import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
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
    final detailAsync = ref.watch(friendDetailProvider(friendId));

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.when(
          data: (friend) => Text(friend.name),
          loading: () => Text(l10n.friendsTitle),
          error: (_, __) => Text(l10n.friendsTitle),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                _confirmDelete(context, ref, l10n);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.friendDelete),
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            friend.name.isNotEmpty
                                ? friend.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              if (friend.birthLocationName.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  friend.birthLocationName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Synastry scores (placeholder data)
                Text(
                  'Synastry',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          context.pushNamed(
                            'chat',
                            queryParameters: {
                              'scenario_id': 'synastry_reading',
                            },
                          );
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(l10n.askAiAboutThis),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Share: for now just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.shareCard)),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: Text(l10n.shareTitle),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.friendDelete),
        content: Text(l10n.friendDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.friendDelete,
              style: const TextStyle(color: Colors.red),
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
