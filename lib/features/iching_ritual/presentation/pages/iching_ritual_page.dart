import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/mystical_loading_widget.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/iching_state.dart';
import '../providers/iching_providers.dart';
import '../widgets/coin_toss_animation.dart';
import '../widgets/hexagram_builder.dart';
import '../widgets/hexagram_symbol.dart';

class IChingRitualPage extends ConsumerStatefulWidget {
  final String sessionId;

  const IChingRitualPage({super.key, required this.sessionId});

  @override
  ConsumerState<IChingRitualPage> createState() => _IChingRitualPageState();
}

class _IChingRitualPageState extends ConsumerState<IChingRitualPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ichingRitualProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(ichingRitualProvider);

    ref.listen<IChingRitualPageState>(ichingRitualProvider, (prev, next) {
      if (next.step == IChingRitualState.reading &&
          prev?.step != IChingRitualState.reading) {
        final conversationId = next.session?.conversationId;
        if (conversationId != null && context.mounted) {
          context.pushNamed(
            'chatConversation',
            pathParameters: {'id': conversationId},
          );
        }
      }
      if (next.step == IChingRitualState.cancelled) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.ichingRitualTitle,
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
          onPressed: () => ref.read(ichingRitualProvider.notifier).cancel(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(ritualState, l10n),
    );
  }

  Widget _buildBody(IChingRitualPageState ritualState, AppLocalizations l10n) {
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
      IChingRitualState.question => _buildQuestionView(l10n),
      IChingRitualState.tossing => _buildTossingView(ritualState, l10n),
      IChingRitualState.building => _buildBuildingView(ritualState, l10n),
      IChingRitualState.revealing => _buildRevealView(ritualState, l10n),
      IChingRitualState.reading ||
      IChingRitualState.completed => _buildReadingView(ritualState, l10n),
      IChingRitualState.cancelled => _buildCancelledView(l10n),
    };
  }

  Widget _buildQuestionView(AppLocalizations l10n) {
    return const StarfieldBackground(
      child: Center(child: MysticalLoadingWidget()),
    );
  }

  Widget _buildTossingView(
    IChingRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final round = ritualState.currentRound;
    final tosses = ritualState.localTosses;

    return StarfieldBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                l10n.ichingRound(round + 1),
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i < round
                          ? CosmicColors.primaryLight
                          : CosmicColors.surface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Coin toss area
              Expanded(
                child: Center(
                  child: CoinTossAnimation(
                    onToss: ritualState.allTossesComplete
                        ? null
                        : () {
                            ref.read(ichingRitualProvider.notifier).tossCoin();
                          },
                  ),
                ),
              ),
              // Hexagram preview from bottom up
              if (tosses.isNotEmpty)
                HexagramBuilder(tosses: tosses, animate: true),
              const SizedBox(height: 16),
              if (ritualState.allTossesComplete)
                CosmicRitualButton(
                  label: l10n.ichingBuildHexagram,
                  isLoading: ritualState.isLoading,
                  onPressed: () =>
                      ref.read(ichingRitualProvider.notifier).finishTossing(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingView(
    IChingRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    return StarfieldBackground(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.ichingBuilding,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              HexagramBuilder(tosses: ritualState.localTosses, animate: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevealView(
    IChingRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    final primary = ritualState.session?.primaryHexagram;
    final transformed = ritualState.session?.transformedHexagram;

    return StarfieldBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (primary != null) ...[
                Text(
                  l10n.ichingPrimaryHexagram,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                HexagramSymbol(hexagram: primary),
              ],
              if (transformed != null) ...[
                const SizedBox(height: 32),
                const Icon(
                  Icons.arrow_downward,
                  color: CosmicColors.secondary,
                  size: 24,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.ichingTransformedHexagram,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                HexagramSymbol(hexagram: transformed),
              ],
              const SizedBox(height: 32),
              CosmicRitualButton(
                label: l10n.ichingBeginReading,
                onPressed: () =>
                    ref.read(ichingRitualProvider.notifier).startReading(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingView(
    IChingRitualPageState ritualState,
    AppLocalizations l10n,
  ) {
    return _buildRevealView(ritualState, l10n);
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
              l10n.ichingCancelled,
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
