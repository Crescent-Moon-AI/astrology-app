import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/dice_state.dart';
import '../providers/dice_providers.dart';
import '../widgets/dice_3d.dart';
import '../widgets/dice_tray.dart';
import '../widgets/dice_meaning_card.dart';

class DiceRitualPage extends ConsumerStatefulWidget {
  const DiceRitualPage({super.key});

  @override
  ConsumerState<DiceRitualPage> createState() => _DiceRitualPageState();
}

class _DiceRitualPageState extends ConsumerState<DiceRitualPage> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(diceRitualProvider);

    ref.listen<DiceRitualState>(diceRitualProvider, (prev, next) {
      if (next.step == DiceState.reading && prev?.step != DiceState.reading) {
        // Navigate to chat for AI reading with dice results
        if (context.mounted) {
          final result = next.diceResult;
          final isZh = Localizations.localeOf(
            context,
          ).languageCode.startsWith('zh');
          final prompt = result != null
              ? (isZh
                    ? '我刚刚掷了骰子，结果是 ${result.dice.join(", ")}，总和 ${result.total}。请为我解读这次骰子占卜的含义。'
                    : 'I just rolled the dice and got ${result.dice.join(", ")}, total ${result.total}. Please interpret this dice divination for me.')
              : l10n.diceReadingPrompt;
          context.pushNamed(
            'chat',
            queryParameters: {'initial_message': prompt},
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.diceRitualTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: SafeArea(child: _buildBody(state, l10n)),
      ),
    );
  }

  Widget _buildBody(DiceRitualState state, AppLocalizations l10n) {
    return switch (state.step) {
      DiceState.idle => _buildIdleView(state, l10n),
      DiceState.rolling => _buildRollingView(state, l10n),
      DiceState.revealed => _buildRevealedView(state, l10n),
      DiceState.reading => _buildRevealedView(state, l10n),
    };
  }

  Widget _buildIdleView(DiceRitualState state, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.casino_outlined,
            size: 80,
            color: CosmicColors.primaryLight,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.dicePrompt,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _questionController,
            style: const TextStyle(color: CosmicColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.diceQuestionHint,
              hintStyle: const TextStyle(color: CosmicColors.textTertiary),
              filled: true,
              fillColor: CosmicColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.primaryLight),
              ),
            ),
            maxLines: 2,
            onChanged: (value) =>
                ref.read(diceRitualProvider.notifier).setQuestion(value),
          ),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.diceRollButton,
            onPressed: () => ref.read(diceRitualProvider.notifier).rollDice(),
          ),
        ],
      ),
    );
  }

  Widget _buildRollingView(DiceRitualState state, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.diceRolling,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          const DiceTray(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dice3D(value: null, isRolling: true),
                SizedBox(width: 16),
                Dice3D(value: null, isRolling: true),
                SizedBox(width: 16),
                Dice3D(value: null, isRolling: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedView(DiceRitualState state, AppLocalizations l10n) {
    final result = state.diceResult;
    if (result == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          DiceTray(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < result.dice.length; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Dice3D(value: result.dice[i], isRolling: false),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${l10n.diceTotal}: ${result.total}',
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          DiceMeaningCard(result: result),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.diceGetReading,
            onPressed: () =>
                ref.read(diceRitualProvider.notifier).startReading(),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.read(diceRitualProvider.notifier).reset(),
            child: Text(
              l10n.diceRollAgain,
              style: const TextStyle(color: CosmicColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
