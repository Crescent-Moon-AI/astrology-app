import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../providers/tarot_ritual_providers.dart';
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CosmicColors.background, Color(0xFF1A0A3E)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  Text(
                    isZh
                        ? '\u8BA9\u95EE\u9898\u5728\u5FC3\u4E2D\u6D6E\u73B0'
                        : 'Let the question arise in your mind',
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isZh
                        ? '\u62BD\u7B2C ${selected.length + 1} \u5F20\u724C\uFF08\u5171 $needed \u5F20\uFF09'
                        : l10n.tarotPickCards(needed),
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Card fan/scroll area
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _totalCards,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemBuilder: (context, index) {
                      final isSelected = selected.contains(index);
                      // Fan effect: slight rotation based on position
                      final centerOffset =
                          (index - _totalCards / 2) / _totalCards;
                      final rotation = centerOffset * 0.15;

                      return GestureDetector(
                        onTap: () => notifier.selectCard(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          transform: Matrix4.identity()
                            ..translateByDouble(
                              0.0,
                              isSelected ? -20.0 : 0.0,
                              0.0,
                              1.0,
                            )
                            ..rotateZ(rotation),
                          transformAlignment: Alignment.bottomCenter,
                          child: Stack(
                            children: [
                              TarotCardBack(width: 60, height: 100),
                              if (isSelected)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: CosmicColors.secondary,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CosmicColors.secondary
                                              .withAlpha(128), // 50%
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (isSelected)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: CosmicColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${selected.toList().indexOf(index) + 1}',
                                        style: const TextStyle(
                                          color: CosmicColors.background,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
