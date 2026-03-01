import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/spread_type.dart';
import '../providers/tarot_ritual_providers.dart';

class SpreadSelectionPage extends ConsumerStatefulWidget {
  final String? conversationId;

  const SpreadSelectionPage({
    super.key,
    this.conversationId,
  });

  @override
  ConsumerState<SpreadSelectionPage> createState() =>
      _SpreadSelectionPageState();
}

class _SpreadSelectionPageState extends ConsumerState<SpreadSelectionPage> {
  SpreadType _selectedSpread = SpreadType.threeCard;
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  static const _spreadEmojis = {
    SpreadType.single: '\uD83C\uDCCF',
    SpreadType.threeCard: '\uD83C\uDCA0',
    SpreadType.loveSpread: '\u2764\uFE0F',
    SpreadType.celticCross: '\u2726',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);

    ref.listen<TarotRitualState>(tarotRitualProvider, (prev, next) {
      if (next.session != null && prev?.session == null) {
        context.pushReplacementNamed(
          'tarotRitual',
          pathParameters: {'sessionId': next.session!.id},
        );
      }
      if (next.error != null && prev?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.tarotSelectSpread,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background.withValues(alpha: 0.9),
        elevation: 0,
      ),
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Header
                    Center(
                      child: Text(
                        isZh ? '让问题在心中浮现' : 'Let the question arise in your mind',
                        style: const TextStyle(
                          color: CosmicColors.textSecondary,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question input
                    TextField(
                      controller: _questionController,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.tarotEnterQuestion,
                        labelStyle: const TextStyle(
                          color: CosmicColors.textSecondary,
                        ),
                        prefixIcon: const Icon(Icons.help_outline,
                            color: CosmicColors.primaryLight, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: CosmicColors.borderGlow),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: CosmicColors.borderGlow),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: CosmicColors.primary, width: 1.5),
                        ),
                        filled: true,
                        fillColor: CosmicColors.surfaceElevated,
                      ),
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),

                    // Spread type grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                      children: [
                        _SpreadTypeCard(
                          emoji: _spreadEmojis[SpreadType.single]!,
                          title: l10n.tarotSpreadSingle,
                          description: l10n.tarotSpreadSingleDesc,
                          cardCount: SpreadType.single.cardCount,
                          isSelected: _selectedSpread == SpreadType.single,
                          onTap: () =>
                              setState(() => _selectedSpread = SpreadType.single),
                        ),
                        _SpreadTypeCard(
                          emoji: _spreadEmojis[SpreadType.threeCard]!,
                          title: l10n.tarotSpreadThreeCard,
                          description: l10n.tarotSpreadThreeCardDesc,
                          cardCount: SpreadType.threeCard.cardCount,
                          isSelected: _selectedSpread == SpreadType.threeCard,
                          onTap: () => setState(
                              () => _selectedSpread = SpreadType.threeCard),
                        ),
                        _SpreadTypeCard(
                          emoji: _spreadEmojis[SpreadType.loveSpread]!,
                          title: l10n.tarotSpreadLove,
                          description: l10n.tarotSpreadLoveDesc,
                          cardCount: SpreadType.loveSpread.cardCount,
                          isSelected: _selectedSpread == SpreadType.loveSpread,
                          onTap: () => setState(
                              () => _selectedSpread = SpreadType.loveSpread),
                        ),
                        _SpreadTypeCard(
                          emoji: _spreadEmojis[SpreadType.celticCross]!,
                          title: l10n.tarotSpreadCelticCross,
                          description: l10n.tarotSpreadCelticCrossDesc,
                          cardCount: SpreadType.celticCross.cardCount,
                          isSelected: _selectedSpread == SpreadType.celticCross,
                          onTap: () => setState(
                              () => _selectedSpread = SpreadType.celticCross),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Start button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: CosmicColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ritualState.isLoading ? null : _startRitual,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: ritualState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: CosmicColors.textPrimary,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.style,
                                        color: CosmicColors.textPrimary,
                                        size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.tarotRitualTitle,
                                      style: const TextStyle(
                                        color: CosmicColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }

  void _startRitual() {
    ref.read(tarotRitualProvider.notifier).createSession(
          conversationId: widget.conversationId ?? '',
          spreadType: _selectedSpread.value,
          question: _questionController.text.trim(),
        );
  }
}

class _SpreadTypeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final int cardCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpreadTypeCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.cardCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CosmicColors.primary.withValues(alpha: 0.35),
                    CosmicColors.surfaceElevated,
                  ],
                )
              : null,
          color: isSelected ? null : CosmicColors.surfaceElevated,
          border: Border.all(
            color: isSelected ? CosmicColors.primary : CosmicColors.borderGlow,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CosmicColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? CosmicColors.textPrimary
                      : CosmicColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: isSelected
                      ? CosmicColors.textSecondary
                      : CosmicColors.textTertiary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.tarotCardCount(cardCount),
                style: TextStyle(
                  color: isSelected
                      ? CosmicColors.secondary
                      : CosmicColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
