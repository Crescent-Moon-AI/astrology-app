import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/shuffle_animation.dart';

class TarotShufflePage extends ConsumerStatefulWidget {
  const TarotShufflePage({super.key});

  @override
  ConsumerState<TarotShufflePage> createState() => _TarotShufflePageState();
}

class _TarotShufflePageState extends ConsumerState<TarotShufflePage> {
  bool _shuffleComplete = false;

  void _onShuffleComplete() {
    if (mounted) setState(() => _shuffleComplete = true);
  }

  static String _spreadDisplayName(String? spreadType, bool isZh) {
    if (spreadType == null) {
      return isZh ? '万能三牌阵' : 'Three Card';
    }
    if (isZh) {
      return switch (spreadType) {
        'three_card' => '万能三牌阵',
        'celtic_cross' => '凯尔特十字',
        'single_card' => '单牌',
        'love_spread' => '爱情牌阵',
        _ => spreadType,
      };
    }
    return switch (spreadType) {
      'three_card' => 'Three Card',
      'celtic_cross' => 'Celtic Cross',
      'single_card' => 'Single Card',
      'love_spread' => 'Love Spread',
      _ => spreadType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);

    return StarfieldBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: CosmicColors.textPrimary,
                    size: 28,
                  ),
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Title
            AnimatedOpacity(
              opacity: _shuffleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                isZh ? '牌洗好了' : 'Cards Shuffled',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            AnimatedOpacity(
              opacity: _shuffleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                isZh ? '请保持专注，准备好后点击继续' : 'Stay focused and tap to continue',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Spread badge
            AnimatedOpacity(
              opacity: _shuffleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withAlpha(26)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isZh ? '牌阵：' : 'Spread: ',
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _spreadDisplayName(ritualState.session?.spreadType, isZh),
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Card stack animation
            ShuffleAnimation(onComplete: _onShuffleComplete),

            const Spacer(flex: 2),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedOpacity(
                opacity: _shuffleComplete ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: CosmicRitualButton(
                  label: isZh ? '继续' : 'Continue',
                  onPressed: _shuffleComplete
                      ? () => ref
                            .read(tarotRitualProvider.notifier)
                            .advanceShuffle()
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
