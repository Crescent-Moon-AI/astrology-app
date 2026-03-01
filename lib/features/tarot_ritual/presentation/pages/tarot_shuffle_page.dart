import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/shuffle_animation.dart';

class TarotShufflePage extends ConsumerStatefulWidget {
  const TarotShufflePage({super.key});

  @override
  ConsumerState<TarotShufflePage> createState() => _TarotShufflePageState();
}

class _TarotShufflePageState extends ConsumerState<TarotShufflePage> {
  bool _shuffleComplete = false;

  @override
  void initState() {
    super.initState();
    // Shuffle completes after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _shuffleComplete = true);
      }
    });
  }

  static String _spreadDisplayName(String? spreadType, bool isZh) {
    if (spreadType == null) {
      return isZh ? '\u4E07\u80FD\u4E09\u724C\u9635' : 'Three Card';
    }
    if (isZh) {
      return switch (spreadType) {
        'three_card' => '\u4E07\u80FD\u4E09\u724C\u9635',
        'celtic_cross' => '\u51EF\u5C14\u7279\u5341\u5B57',
        'single_card' => '\u5355\u724C',
        _ => spreadType,
      };
    }
    return switch (spreadType) {
      'three_card' => 'Three Card',
      'celtic_cross' => 'Celtic Cross',
      'single_card' => 'Single Card',
      _ => spreadType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CosmicColors.background,
            Color(0xFF1A0A3E),
            CosmicColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),

            // Shuffle animation
            const ShuffleAnimation(),
            const SizedBox(height: 32),

            // Title
            AnimatedOpacity(
              opacity: _shuffleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                isZh ? '\u724C\u6D17\u597D\u4E86' : 'Cards Shuffled',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            AnimatedOpacity(
              opacity: _shuffleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                isZh
                    ? '\u8BF7\u4FDD\u6301\u4E13\u6CE8\uFF0C\u51C6\u5907\u597D\u540E\u70B9\u51FB\u7EE7\u7EED'
                    : 'Stay focused and tap to continue',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Spread badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CosmicColors.primary.withAlpha(38), // 15%
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: CosmicColors.primary.withAlpha(51), // 20%
                ),
              ),
              child: Text(
                isZh
                    ? '\u724C\u9635\uFF1A${_spreadDisplayName(ritualState.session?.spreadType, isZh)}'
                    : 'Spread: ${_spreadDisplayName(ritualState.session?.spreadType, isZh)}',
                style: const TextStyle(
                  color: CosmicColors.primaryLight,
                  fontSize: 12,
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedOpacity(
                opacity: _shuffleComplete ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: CosmicRitualButton(
                  label: isZh ? '\u7EE7\u7EED' : 'Continue',
                  onPressed: _shuffleComplete
                      ? () => ref
                            .read(tarotRitualProvider.notifier)
                            .advanceShuffle()
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
