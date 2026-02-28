import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../providers/tarot_ritual_providers.dart';
import '../widgets/tarot_card_back.dart';

class CardPickerPage extends ConsumerWidget {
  const CardPickerPage({super.key});

  static const _totalCards = 78;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
            Color(0xFF0A0520),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selected.length} / $needed',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
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
                                        color: const Color(0xFFD4AF37),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFD4AF37)
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
                                      color: Color(0xFFD4AF37),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${selected.toList().indexOf(index) + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
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
                child: FilledButton(
                  onPressed: ritualState.selectionComplete &&
                          !ritualState.isLoading
                      ? () => notifier.confirmSelection()
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white38,
                  ),
                  child: ritualState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.tarotConfirmSelection),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
