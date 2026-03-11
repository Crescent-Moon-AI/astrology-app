import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../domain/models/ritual_state.dart';
import '../../domain/models/spread_type.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/shuffle_animation.dart';

/// Entry page for the tarot ritual flow.
///
/// Matches the real app: shows "牌洗好了" with a card back stack,
/// a tappable spread selector badge, and a "继续" button.
/// Auto-creates a session with the selected spread when the user taps continue.
class SpreadSelectionPage extends ConsumerStatefulWidget {
  final String? conversationId;
  final String? initialQuestion;

  const SpreadSelectionPage({super.key, this.conversationId, this.initialQuestion});

  @override
  ConsumerState<SpreadSelectionPage> createState() =>
      _SpreadSelectionPageState();
}

class _SpreadSelectionPageState extends ConsumerState<SpreadSelectionPage> {
  SpreadType _selectedSpread = SpreadType.universalThree;

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);

    // Navigate to ritual page when session advances past shuffling
    ref.listen<TarotRitualState>(tarotRitualProvider, (prev, next) {
      if (next.session != null &&
          next.step == RitualState.pickingCards &&
          prev?.step != RitualState.pickingCards) {
        context.pushReplacementNamed(
          'tarotRitual',
          pathParameters: {'sessionId': next.session!.id},
          queryParameters: widget.initialQuestion?.isNotEmpty == true
              ? {'initial_question': widget.initialQuestion!}
              : {},
        );
      }
      if (next.error != null && prev?.error == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      backgroundColor: CosmicColors.backgroundDeep,
      body: StarfieldBackground(
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

              // Title: "牌洗好了"
              Text(
                isZh ? '牌洗好了' : 'Cards Shuffled',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                isZh ? '请保持专注，准备好后点击继续' : 'Stay focused and tap to continue',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Tappable spread badge
              GestureDetector(
                onTap: () => _showSpreadPicker(context, isZh),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(13), // ~5%
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha(26), // ~10%
                    ),
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
                        isZh ? _selectedSpread.nameZH : _selectedSpread.nameEN,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.swap_horiz,
                        color: CosmicColors.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Card stack animation (center)
              const ShuffleAnimation(),

              const Spacer(flex: 2),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CosmicRitualButton(
                  label: isZh ? '继续' : 'Continue',
                  onPressed: ritualState.isLoading ? null : _startRitual,
                  isLoading: ritualState.isLoading,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _startRitual() async {
    final notifier = ref.read(tarotRitualProvider.notifier);
    await notifier.createSession(
      conversationId: widget.conversationId ?? '',
      spreadType: _selectedSpread.value,
    );
    await notifier.advanceShuffle();
  }

  void _showSpreadPicker(BuildContext context, bool isZh) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CosmicColors.surfaceElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
                  child: Text(
                    isZh ? '选择牌阵' : 'Select Spread',
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final spread in SpreadType.values)
                          ListTile(
                            leading: Icon(
                              _selectedSpread == spread
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: _selectedSpread == spread
                                  ? CosmicColors.primary
                                  : CosmicColors.textTertiary,
                              size: 20,
                            ),
                            title: Text(
                              isZh ? spread.nameZH : spread.nameEN,
                              style: TextStyle(
                                color: _selectedSpread == spread
                                    ? CosmicColors.textPrimary
                                    : CosmicColors.textSecondary,
                                fontWeight: _selectedSpread == spread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              isZh ? spread.descZH : spread.descEN,
                              style: const TextStyle(
                                color: CosmicColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              setState(() => _selectedSpread = spread);
                              Navigator.pop(ctx);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
