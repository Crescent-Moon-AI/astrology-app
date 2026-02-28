import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../domain/models/ritual_state.dart';
import '../providers/tarot_ritual_providers.dart';
import 'tarot_shuffle_page.dart';
import 'card_picker_page.dart';
import 'card_reveal_page.dart';
import 'spread_overview_page.dart';

class TarotRitualPage extends ConsumerStatefulWidget {
  final String sessionId;

  const TarotRitualPage({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<TarotRitualPage> createState() => _TarotRitualPageState();
}

class _TarotRitualPageState extends ConsumerState<TarotRitualPage> {
  @override
  void initState() {
    super.initState();
    // Load session data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tarotRitualProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(tarotRitualProvider);

    // Listen for reading state to navigate to chat
    ref.listen<TarotRitualState>(tarotRitualProvider, (prev, next) {
      if (next.step == RitualState.reading && prev?.step != RitualState.reading) {
        final conversationId = next.session?.conversationId;
        if (conversationId != null && context.mounted) {
          context.pushNamed(
            'chatConversation',
            pathParameters: {'id': conversationId},
          );
        }
      }
      if (next.step == RitualState.cancelled) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tarotRitualTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showCancelDialog(context, ref),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(ritualState),
    );
  }

  Widget _buildBody(TarotRitualState ritualState) {
    if (ritualState.isLoading && ritualState.session == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ritualState.error != null && ritualState.session == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(ritualState.error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref
                  .read(tarotRitualProvider.notifier)
                  .loadSession(widget.sessionId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return switch (ritualState.step) {
      RitualState.shuffling => const TarotShufflePage(),
      RitualState.pickingCards || RitualState.confirming => const CardPickerPage(),
      RitualState.revealing => const CardRevealPage(),
      RitualState.reading || RitualState.completed => const SpreadOverviewPage(),
      RitualState.cancelled || RitualState.expired => _buildEndedView(),
    };
  }

  Widget _buildEndedView() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0520),
            Color(0xFF1A0A3E),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 48,
              color: Colors.white38,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.tarotCancel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white60,
                side: const BorderSide(color: Colors.white38),
              ),
              child: Text(l10n.tarotResume),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.tarotCancel),
        content: const Text('Are you sure you want to cancel this reading?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.tarotResume),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(tarotRitualProvider.notifier).cancel();
            },
            child: Text(l10n.tarotCancel),
          ),
        ],
      ),
    );
  }
}
