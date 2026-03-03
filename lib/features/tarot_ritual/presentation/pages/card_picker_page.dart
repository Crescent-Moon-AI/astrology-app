import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/card_fan_picker.dart';
import '../widgets/tarot_card_back.dart';

class CardPickerPage extends ConsumerWidget {
  const CardPickerPage({super.key});

  static const _totalCards = 78;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);
    final notifier = ref.read(tarotRitualProvider.notifier);

    final needed = ritualState.totalCards;
    final selected = ritualState.selectedPositions;

    return Container(
      color: CosmicColors.backgroundDeep,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                isZh
                    ? '\u8BA9\u95EE\u9898\u5728\u5FC3\u4E2D\u6D6E\u73B0'
                    : 'Let the question arise in your mind',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                isZh
                    ? (selected.length >= needed
                          ? '\u5DF2\u9009 $needed \u5F20\u724C'
                          : '\u62BD\u7B2C ${selected.length + 1} \u5F20\u724C\uFF08\u5171 $needed \u5F20\uFF09')
                    : l10n.tarotPickCards(needed),
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),

            // Position slots — tappable to undo selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _PositionSlots(
                needed: needed,
                filledCount: selected.length,
                onSlotTapped: (slotIndex) {
                  if (slotIndex < selected.length) {
                    HapticFeedback.lightImpact();
                    final cardIndex = selected.elementAt(slotIndex);
                    notifier.deselectCard(cardIndex);
                  }
                },
              ),
            ),

            // Undo hint
            AnimatedOpacity(
              opacity: selected.isNotEmpty && !ritualState.selectionComplete
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 2),
                child: Text(
                  isZh ? '点击牌位可撤回' : 'Tap a slot to undo',
                  style: TextStyle(
                    color: CosmicColors.textTertiary.withAlpha(128),
                    fontSize: 11,
                  ),
                ),
              ),
            ),

            // Card fan area
            Expanded(
              child: CardFanPicker(
                totalCards: _totalCards,
                selectedPositions: selected,
                onCardSelected: (index) => notifier.selectCard(index),
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: CosmicRitualButton(
                label: isZh ? '\u7EE7\u7EED' : l10n.tarotConfirmSelection,
                onPressed:
                    ritualState.selectionComplete && !ritualState.isLoading
                    ? () => notifier.confirmSelection()
                    : null,
                isLoading: ritualState.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row of position slot indicators with tap-to-undo support.
///
/// Filled slots show a card back with a scale-in animation.
/// Tapping a filled slot deselects that card (card returns to the fan).
class _PositionSlots extends StatelessWidget {
  final int needed;
  final int filledCount;
  final ValueChanged<int>? onSlotTapped;

  const _PositionSlots({
    required this.needed,
    required this.filledCount,
    this.onSlotTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Slot size responsive to count
    final slotWidth = needed <= 3 ? 56.0 : (needed <= 5 ? 44.0 : 36.0);
    final slotHeight = slotWidth / 0.6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(needed, (i) {
        final isFilled = i < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: isFilled ? () => onSlotTapped?.call(i) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: slotWidth,
              height: slotHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isFilled
                      ? CosmicColors.secondary
                      : CosmicColors.textTertiary.withAlpha(64),
                  width: isFilled ? 2 : 1,
                ),
                boxShadow: isFilled
                    ? [
                        BoxShadow(
                          color: CosmicColors.secondary.withAlpha(51),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: isFilled
                      ? TarotCardBack(
                          key: const ValueKey('filled'),
                          width: slotWidth,
                          height: slotHeight,
                        )
                      : Center(
                          key: const ValueKey('empty'),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: CosmicColors.textTertiary.withAlpha(77),
                              fontSize: slotWidth * 0.4,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
