import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../domain/models/tarot_card.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/tarot_card_3d.dart';
import '../widgets/position_indicator.dart';

class CardRevealPage extends ConsumerWidget {
  const CardRevealPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
            Color(0xFF0A0520),
            Color(0xFF1A0A3E),
            Color(0xFF0A0520),
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
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFD4AF37),
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
                          ? const Color(0xFFD4AF37)
                          : isCurrent
                              ? const Color(0xFFD4AF37).withValues(alpha: 0.5)
                              : Colors.white12,
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
                      child: FilledButton(
                        onPressed: ritualState.isLoading
                            ? null
                            : () => notifier.startReading(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
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
                            : Text(l10n.tarotBeginReading),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => notifier.revealNextCard(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD4AF37),
                          side: const BorderSide(color: Color(0xFFD4AF37)),
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
    final theme = Theme.of(context);
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
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (card.nameZH.isNotEmpty)
          Text(
            card.nameZH,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white60,
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
                  ? Colors.green.shade300
                  : Colors.red.shade300,
            ),
            const SizedBox(width: 4),
            Text(
              card.isUpright ? 'Upright' : 'Reversed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: card.isUpright
                    ? Colors.green.shade300
                    : Colors.red.shade300,
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
              .map((kw) => Chip(
                    label: Text(
                      kw,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor:
                        const Color(0xFF4A1A7A).withValues(alpha: 0.5),
                    labelStyle: const TextStyle(color: Colors.white70),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide.none,
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.auto_awesome,
          size: 48,
          color: Color(0xFFD4AF37),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.tarotReadingComplete,
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${cards.length} cards revealed',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}
