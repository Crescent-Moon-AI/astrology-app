import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/mystical_loading_widget.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/rune_state.dart';
import '../providers/rune_providers.dart';
import '../widgets/rune_stone.dart';
import '../widgets/rune_bag.dart';
import '../widgets/rune_spread_layout.dart';

class RuneRitualPage extends ConsumerStatefulWidget {
  final String sessionId;

  const RuneRitualPage({super.key, required this.sessionId});

  @override
  ConsumerState<RuneRitualPage> createState() => _RuneRitualPageState();
}

class _RuneRitualPageState extends ConsumerState<RuneRitualPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(runeRitualProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(runeRitualProvider);

    ref.listen<RuneRitualPageState>(runeRitualProvider, (prev, next) {
      if (next.step == RuneRitualState.reading &&
          prev?.step != RuneRitualState.reading) {
        final conversationId = next.session?.conversationId;
        if (conversationId != null && context.mounted) {
          context.pushNamed(
            'chatConversation',
            pathParameters: {'id': conversationId},
          );
        }
      }
      if (next.step == RuneRitualState.cancelled) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.runeRitualTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(runeRitualProvider.notifier).cancel();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(ritualState, l10n),
    );
  }

  Widget _buildBody(RuneRitualPageState ritualState, AppLocalizations l10n) {
    if (ritualState.isLoading && ritualState.session == null) {
      return const StarfieldBackground(
        child: Center(child: MysticalLoadingWidget()),
      );
    }

    if (ritualState.error != null && ritualState.session == null) {
      return StarfieldBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: CosmicColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                ritualState.error!,
                style: const TextStyle(color: CosmicColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return switch (ritualState.step) {
      RuneRitualState.selectSpread ||
      RuneRitualState.drawing => _buildDrawingView(ritualState, l10n),
      RuneRitualState.revealing => _buildRevealView(ritualState, l10n),
      RuneRitualState.reading ||
      RuneRitualState.completed => _buildOverviewView(ritualState, l10n),
      RuneRitualState.cancelled => _buildCancelledView(l10n),
    };
  }

  Widget _buildDrawingView(
    RuneRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    return StarfieldBackground(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.runeDrawPrompt,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            RuneBag(
              onTap: () {
                ref.read(runeRitualProvider.notifier).advanceDrawing();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealView(
    RuneRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final runes = ritualState.session?.drawnRunes ?? [];

    return StarfieldBackground(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: RuneSpreadLayout(
                runes: runes,
                revealIndex: ritualState.revealIndex,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ritualState.allRevealed
                  ? CosmicRitualButton(
                      label: l10n.runeBeginReading,
                      onPressed: () =>
                          ref.read(runeRitualProvider.notifier).startReading(),
                    )
                  : CosmicRitualButton(
                      label: l10n.runeRevealNext,
                      onPressed: () => ref
                          .read(runeRitualProvider.notifier)
                          .revealNextRune(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewView(
    RuneRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final runes = ritualState.session?.drawnRunes ?? [];

    return StarfieldBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              for (final rune in runes) ...[
                RuneStone(rune: rune, size: 80),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelledView(AppLocalizations l10n) {
    return StarfieldBackground(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 48,
              color: CosmicColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.runeCancelled,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
