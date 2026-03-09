import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../domain/models/tarot_card.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/tarot_card_3d.dart';
import '../widgets/position_indicator.dart';

class CardRevealPage extends ConsumerWidget {
  const CardRevealPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);
    final notifier = ref.read(tarotRitualProvider.notifier);

    final cards = ritualState.session?.selectedCards ?? [];
    final revealIndex = ritualState.revealIndex;
    final currentIndex = revealIndex < cards.length ? revealIndex : null;

    return Container(
      color: CosmicColors.backgroundDeep,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isZh
                    ? '\u63ED\u793A\u547D\u8FD0\u4E4B\u724C'
                    : l10n.tarotRevealing,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 24,
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
                          ? CosmicColors.secondary.withAlpha(128) // 50%
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
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: ritualState.allRevealed
                  ? CosmicRitualButton(
                      label: isZh
                          ? '\u5F00\u59CB\u89E3\u8BFB'
                          : l10n.tarotBeginReading,
                      onPressed: ritualState.isLoading
                          ? null
                          : () => notifier.startReading(),
                      isLoading: ritualState.isLoading,
                    )
                  : CosmicRitualButton(
                      label: isZh
                          ? '\u7FFB\u5F00\u4E0B\u4E00\u5F20'
                          : l10n.tarotRevealNext,
                      onPressed: () => notifier.revealNextCard(),
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

  const _CardRevealItem({super.key, required this.resolvedCard});

  @override
  Widget build(BuildContext context) {
    final card = resolvedCard.card;
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    // Responsive card sizing: ~65% of screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.65;
    final cardHeight = cardWidth / 0.6;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Position label
        PositionIndicator(label: resolvedCard.positionLabel, isActive: true),
        const SizedBox(height: 12),

        // 3D flip card — large, near-fullscreen
        TarotCard3D(
          card: card,
          showFace: true,
          width: cardWidth,
          height: cardHeight,
        ),
        const SizedBox(height: 12),

        // Card name + element tag
        Text(
          card.nameZH.isNotEmpty ? card.nameZH : card.name,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (card.nameZH.isNotEmpty)
          Text(
            card.name,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
        const SizedBox(height: 8),

        // Element tag + orientation
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (card.element.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CosmicColors.primary.withAlpha(38), // 15%
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CosmicColors.primary.withAlpha(64), // 25%
                  ),
                ),
                child: Text(
                  _elementLabel(card.element, isZh),
                  style: const TextStyle(
                    color: CosmicColors.primaryLight,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              card.isUpright ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: card.isUpright ? CosmicColors.success : CosmicColors.error,
            ),
            const SizedBox(width: 2),
            Text(
              card.isUpright
                  ? (isZh ? '\u6B63\u4F4D' : 'Upright')
                  : (isZh ? '\u9006\u4F4D' : 'Reversed'),
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
          children: card
              .localizedKeywords(isZh)
              .take(3)
              .map(
                (kw) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CosmicColors.primary.withAlpha(51), // 20%
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CosmicColors.primary.withAlpha(77), // 30%
                    ),
                  ),
                  child: Text(
                    kw,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 11,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  static String _elementLabel(String element, bool isZh) {
    if (!isZh) return element;
    final zhMap = {
      'fire': '\u706B\u5143\u7D20',
      'water': '\u6C34\u5143\u7D20',
      'air': '\u98CE\u5143\u7D20',
      'earth': '\u571F\u5143\u7D20',
    };
    return zhMap[element.toLowerCase()] ?? element;
  }
}

class _AllRevealedMessage extends StatelessWidget {
  final List<ResolvedCard> cards;
  final int revealedCount;

  const _AllRevealedMessage({required this.cards, required this.revealedCount});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.auto_awesome, size: 48, color: CosmicColors.secondary),
        const SizedBox(height: 16),
        Text(
          isZh ? '\u6240\u6709\u724C\u5DF2\u63ED\u793A' : 'All cards revealed',
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isZh
              ? '\u5171 ${cards.length} \u5F20\u724C\uFF0C\u8BA9\u6211\u4EEC\u5F00\u59CB\u89E3\u8BFB'
              : '${cards.length} cards ready for reading',
          style: const TextStyle(
            color: CosmicColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
