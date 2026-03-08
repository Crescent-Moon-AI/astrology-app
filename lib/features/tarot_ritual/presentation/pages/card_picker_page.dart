import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/tarot_card.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/card_fan_picker.dart';
import '../widgets/tarot_card_3d.dart';
import '../widgets/tarot_card_back.dart';
import '../widgets/tarot_card_face.dart';

class CardPickerPage extends ConsumerStatefulWidget {
  const CardPickerPage({super.key});

  static const _totalCards = 78;

  @override
  ConsumerState<CardPickerPage> createState() => _CardPickerPageState();
}

class _CardPickerPageState extends ConsumerState<CardPickerPage> {
  /// false = card-slots view, true = card-fan view
  bool _showFan = false;

  /// When non-null, shows the confirm overlay for this card index.
  int? _pendingCardIndex;

  /// The card resolved from the draw API after confirm.
  TarotCard? _drawnCard;

  /// Whether the flip animation has been triggered.
  bool _showFlip = false;

  /// Whether we are loading a draw request.
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');
    final ritualState = ref.watch(tarotRitualProvider);
    final notifier = ref.read(tarotRitualProvider.notifier);

    final needed = ritualState.totalCards;
    final selected = ritualState.selectedPositions;

    // Confirm overlay takes priority
    if (_pendingCardIndex != null) {
      return _buildConfirmOverlay(context, isZh, notifier);
    }

    if (!_showFan) {
      return _buildSlotView(context, isZh, needed, selected, notifier, ritualState);
    }
    return _buildFanView(context, isZh, needed, selected, notifier, ritualState);
  }

  /// Confirm overlay: large card with flip animation + "确定" + "换一张"
  Widget _buildConfirmOverlay(
    BuildContext context,
    bool isZh,
    TarotRitualNotifier notifier,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.65;
    final cardHeight = cardWidth / 0.6;

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
                  onPressed: () => setState(() {
                    _pendingCardIndex = null;
                    _drawnCard = null;
                    _showFlip = false;
                    _isDrawing = false;
                  }),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Card with 3D flip animation
            TarotCard3D(
              card: _drawnCard,
              showFace: _showFlip,
              width: cardWidth,
              height: cardHeight,
              onFlipComplete: () {
                // After flip animation completes, wait a moment then go back to slot view
                Future.delayed(const Duration(milliseconds: 600), () {
                  if (mounted) {
                    setState(() {
                      _pendingCardIndex = null;
                      _drawnCard = null;
                      _showFlip = false;
                      _isDrawing = false;
                      _showFan = false; // back to slot view
                    });
                  }
                });
              },
            ),

            const Spacer(flex: 3),

            // Confirm button (hidden after flip starts)
            if (!_showFlip)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CosmicRitualButton(
                  label: isZh ? '确定' : 'Confirm',
                  isLoading: _isDrawing,
                  onPressed: _isDrawing
                      ? null
                      : () async {
                          HapticFeedback.mediumImpact();
                          setState(() => _isDrawing = true);

                          // Call draw API to resolve the card
                          final card =
                              await notifier.drawCard(_pendingCardIndex!);
                          if (card != null && mounted) {
                            setState(() {
                              _drawnCard = card;
                              _showFlip = true;
                              _isDrawing = false;
                            });
                          } else if (mounted) {
                            // Draw failed, go back
                            setState(() {
                              _pendingCardIndex = null;
                              _isDrawing = false;
                            });
                          }
                        },
                ),
              ),
            if (!_showFlip) const SizedBox(height: 16),

            // Change card link (hidden after flip starts)
            if (!_showFlip)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _pendingCardIndex = null;
                    _drawnCard = null;
                    _showFlip = false;
                    _isDrawing = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    isZh ? '换一张' : 'Change card',
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            if (!_showFlip) const SizedBox(height: 32),

            // Spacer when flip is showing (to maintain layout)
            if (_showFlip) const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  /// Slot view: shows card positions and progress
  Widget _buildSlotView(
    BuildContext context,
    bool isZh,
    int needed,
    Set<int> selected,
    TarotRitualNotifier notifier,
    TarotRitualState ritualState,
  ) {
    final allSelected = selected.length >= needed;

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
            Text(
              isZh ? '让问题在心中浮现' : 'Let the question arise',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              allSelected
                  ? (isZh ? '牌已选好，点击继续' : 'Cards selected, tap to continue')
                  : (isZh
                      ? '抽第 ${selected.length + 1} 张牌'
                      : 'Pick card ${selected.length + 1}'),
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // Card slots with drawn card faces
            _PositionSlots(
              needed: needed,
              filledCount: selected.length,
              drawnCards: ritualState.drawnCardsInOrder,
            ),

            const Spacer(flex: 3),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CosmicRitualButton(
                label: isZh ? '继续' : 'Continue',
                onPressed: allSelected
                    ? (ritualState.isLoading
                        ? null
                        : () => notifier.confirmSelection())
                    : () => setState(() => _showFan = true),
                isLoading: ritualState.isLoading,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Fan view: card fan at bottom for picking
  Widget _buildFanView(
    BuildContext context,
    bool isZh,
    int needed,
    Set<int> selected,
    TarotRitualNotifier notifier,
    TarotRitualState ritualState,
  ) {
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
                  onPressed: () => setState(() => _showFan = false),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              isZh ? '用心感受' : 'Feel with your heart',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle instructions
            Text(
              isZh ? '凭直觉点击选牌，滑动牌轮' : 'Tap to select, swipe to browse',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isZh ? '手指可放大牌轮' : 'Pinch to zoom',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
            ),

            // Card fan area
            Expanded(
              child: CardFanPicker(
                totalCards: CardPickerPage._totalCards,
                selectedPositions: selected,
                onCardSelected: (index) {
                  // Show confirm overlay instead of selecting directly
                  setState(() => _pendingCardIndex = index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed card slot indicators — shows card face for drawn cards.
class _PositionSlots extends StatelessWidget {
  final int needed;
  final int filledCount;
  final List<TarotCard> drawnCards;

  const _PositionSlots({
    required this.needed,
    required this.filledCount,
    this.drawnCards = const [],
  });

  @override
  Widget build(BuildContext context) {
    final slotWidth =
        needed <= 3 ? 72.0 : (needed <= 5 ? 52.0 : 40.0);
    final slotHeight = slotWidth / 0.6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(needed, (i) {
        final isFilled = i < filledCount;
        final hasDrawnCard = i < drawnCards.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
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
                child: isFilled
                    ? (hasDrawnCard
                        ? TarotCardFace(
                            card: drawnCards[i],
                            width: slotWidth,
                            height: slotHeight,
                          )
                        : TarotCardBack(
                            width: slotWidth,
                            height: slotHeight,
                          ))
                    : CustomPaint(
                        painter: _DashedBorderPainter(
                          color: CosmicColors.textTertiary.withAlpha(77),
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: CosmicColors.textTertiary.withAlpha(102),
                              fontSize: slotWidth * 0.35,
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

/// Draws a dashed rounded rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length);
        final extractPath = metric.extractPath(distance, end.toDouble());
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color;
}
