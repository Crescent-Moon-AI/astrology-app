import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/mystical_loading_widget.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/lenormand_state.dart';
import '../providers/lenormand_providers.dart';
import '../widgets/lenormand_card_face.dart';

class LenormandRitualPage extends ConsumerStatefulWidget {
  final String sessionId;

  const LenormandRitualPage({super.key, required this.sessionId});

  @override
  ConsumerState<LenormandRitualPage> createState() =>
      _LenormandRitualPageState();
}

class _LenormandRitualPageState extends ConsumerState<LenormandRitualPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lenormandRitualProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(lenormandRitualProvider);

    ref.listen<LenormandRitualPageState>(lenormandRitualProvider, (prev, next) {
      if (next.step == LenormandRitualState.reading &&
          prev?.step != LenormandRitualState.reading) {
        final conversationId = next.session?.conversationId;
        if (conversationId != null && context.mounted) {
          context.pushNamed(
            'chatConversation',
            pathParameters: {'id': conversationId},
          );
        }
      }
      if (next.step == LenormandRitualState.cancelled) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.lenormandRitualTitle,
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
          onPressed: () => ref.read(lenormandRitualProvider.notifier).cancel(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(ritualState, l10n),
    );
  }

  Widget _buildBody(
    LenormandRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    if (ritualState.isLoading && ritualState.session == null) {
      return const StarfieldBackground(
        child: Center(child: MysticalLoadingWidget()),
      );
    }

    if (ritualState.error != null && ritualState.session == null) {
      return StarfieldBackground(
        child: Center(
          child: Text(
            ritualState.error!,
            style: const TextStyle(color: CosmicColors.error),
          ),
        ),
      );
    }

    return switch (ritualState.step) {
      LenormandRitualState.shuffling => _buildShufflingView(l10n),
      LenormandRitualState.pickingCards ||
      LenormandRitualState.confirming => _buildPickingView(ritualState, l10n),
      LenormandRitualState.revealing => _buildRevealView(ritualState, l10n),
      LenormandRitualState.reading ||
      LenormandRitualState.completed => _buildOverviewView(ritualState, l10n),
      LenormandRitualState.cancelled => _buildCancelledView(l10n),
    };
  }

  Widget _buildShufflingView(AppLocalizations l10n) {
    return StarfieldBackground(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.style,
                size: 80,
                color: CosmicColors.primaryLight,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.lenormandShuffling,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              CosmicRitualButton(
                label: l10n.lenormandStartPicking,
                onPressed: () =>
                    ref.read(lenormandRitualProvider.notifier).advanceShuffle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickingView(
    LenormandRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    return StarfieldBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.lenormandPickCards(ritualState.totalCards),
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: 36,
                itemBuilder: (context, index) {
                  final isSelected = ritualState.selectedPositions.contains(
                    index,
                  );
                  return GestureDetector(
                    onTap: () => ref
                        .read(lenormandRitualProvider.notifier)
                        .selectCard(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CosmicColors.primary.withAlpha(77)
                            : CosmicColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? CosmicColors.primaryLight
                              : CosmicColors.borderGlow,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: CosmicColors.primaryLight,
                                size: 20,
                              )
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: CosmicColors.textTertiary,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CosmicRitualButton(
                label: l10n.lenormandConfirmSelection,
                isLoading: ritualState.isLoading,
                onPressed: ritualState.selectionComplete
                    ? () => ref
                          .read(lenormandRitualProvider.notifier)
                          .confirmSelection()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealView(
    LenormandRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final cards = ritualState.session?.selectedCards ?? [];

    return StarfieldBackground(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var i = 0; i < cards.length; i++)
                      AnimatedOpacity(
                        opacity: i < ritualState.revealIndex ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 300),
                        child: LenormandCardFace(
                          card: cards[i].card,
                          width: 80,
                          height: 120,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ritualState.allRevealed
                  ? CosmicRitualButton(
                      label: l10n.lenormandBeginReading,
                      onPressed: () => ref
                          .read(lenormandRitualProvider.notifier)
                          .startReading(),
                    )
                  : CosmicRitualButton(
                      label: l10n.lenormandRevealNext,
                      onPressed: () => ref
                          .read(lenormandRitualProvider.notifier)
                          .revealNextCard(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewView(
    LenormandRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final cards = ritualState.session?.selectedCards ?? [];

    return StarfieldBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final card in cards)
                LenormandCardFace(card: card.card, width: 80, height: 120),
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
              l10n.lenormandCancelled,
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
