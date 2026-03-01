import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/tarot_card.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/tarot_card_3d.dart';
import '../widgets/position_indicator.dart';

class CardRevealPage extends ConsumerWidget {
  const CardRevealPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(tarotRitualProvider);
    final notifier = ref.read(tarotRitualProvider.notifier);

    final cards = ritualState.session?.selectedCards ?? [];
    final revealIndex = ritualState.revealIndex;
    final currentIndex = revealIndex < cards.length ? revealIndex : null;

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
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.tarotRevealing,
                style: const TextStyle(
                  color: CosmicColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Progress indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(cards.length, (i) {
                  final isRevealed = i < revealIndex;
                  final isCurrent = i == currentIndex;
                  return Container(
                    width: 24,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: isRevealed
                          ? CosmicColors.secondary
                          : isCurrent
                              ? CosmicColors.secondary.withValues(alpha: 0.5)
                              : CosmicColors.surfaceElevated,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Card reveal area
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!ritualState.allRevealed) {
                    notifier.revealNextCard();
                  }
                },
                child: Center(
                  child: currentIndex != null
                      ? _CardRevealItem(
                          key: ValueKey('card_$currentIndex'),
                          resolvedCard: cards[currentIndex],
                        )
                      : _AllRevealedMessage(
                          cards: cards,
                          revealedCount: revealIndex,
                        ),
                ),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: ritualState.allRevealed
                  ? SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: CosmicColors.primaryGradient,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CosmicColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: ritualState.isLoading
                                ? null
                                : () => notifier.startReading(),
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
                                      l10n.tarotBeginReading,
                                      style: const TextStyle(
                                        color: CosmicColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => notifier.revealNextCard(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CosmicColors.secondary,
                          side: const BorderSide(color: CosmicColors.secondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(l10n.tarotRevealNext),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardRevealItem extends StatelessWidget {
  final ResolvedCard resolvedCard;

  const _CardRevealItem({
    super.key,
    required this.resolvedCard,
  });

  @override
  Widget build(BuildContext context) {
    final card = resolvedCard.card;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Position label
        PositionIndicator(
          label: resolvedCard.positionLabel,
          isActive: true,
        ),
        const SizedBox(height: 16),

        // 3D flip card
        TarotCard3D(
          card: card,
          showFace: true,
          width: 160,
          height: 266,
        ),
        const SizedBox(height: 16),

        // Card info
        Text(
          card.name,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (card.nameZH.isNotEmpty)
          Text(
            card.nameZH,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 14,
            ),
          ),
        const SizedBox(height: 8),

        // Orientation
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              card.isUpright ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: card.isUpright
                  ? CosmicColors.success
                  : CosmicColors.error,
            ),
            const SizedBox(width: 4),
            Text(
              card.isUpright ? 'Upright' : 'Reversed',
              style: TextStyle(
                color: card.isUpright
                    ? CosmicColors.success
                    : CosmicColors.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Keywords
        Wrap(
          spacing: 8,
          children: card.activeKeywords
              .take(3)
              .map((kw) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CosmicColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            CosmicColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      kw,
                      style: const TextStyle(
                        color: CosmicColors.primaryLight,
                        fontSize: 11,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AllRevealedMessage extends StatelessWidget {
  final List<ResolvedCard> cards;
  final int revealedCount;

  const _AllRevealedMessage({
    required this.cards,
    required this.revealedCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.auto_awesome,
          size: 48,
          color: CosmicColors.secondary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.tarotReadingComplete,
          style: const TextStyle(
            color: CosmicColors.secondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${cards.length} cards revealed',
          style: const TextStyle(
            color: CosmicColors.textTertiary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
