import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/tarot_card_back.dart';

class CardPickerPage extends ConsumerWidget {
  const CardPickerPage({super.key});

  static const _totalCards = 78;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(tarotRitualProvider);
    final notifier = ref.read(tarotRitualProvider.notifier);

    final needed = ritualState.totalCards;
    final selected = ritualState.selectedPositions;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CosmicColors.background,
            Color(0xFF1A0A3E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    l10n.tarotPickCards(needed),
                    style: const TextStyle(
                      color: CosmicColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selected.length} / $needed',
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 14,
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
                              TarotCardBack(
                                width: 60,
                                height: 100,
                              ),
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
                                              .withValues(alpha: 0.5),
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
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: ritualState.selectionComplete &&
                            !ritualState.isLoading
                        ? CosmicColors.primaryGradient
                        : null,
                    color: !ritualState.selectionComplete ||
                            ritualState.isLoading
                        ? CosmicColors.surfaceElevated
                        : null,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: ritualState.selectionComplete
                        ? [
                            BoxShadow(
                              color: CosmicColors.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ritualState.selectionComplete &&
                              !ritualState.isLoading
                          ? () => notifier.confirmSelection()
                          : null,
                      borderRadius: BorderRadius.circular(26),
                      child: Center(
                        child: ritualState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.tarotConfirmSelection,
                                style: TextStyle(
                                  color: ritualState.selectionComplete
                                      ? CosmicColors.textPrimary
                                      : CosmicColors.textTertiary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
