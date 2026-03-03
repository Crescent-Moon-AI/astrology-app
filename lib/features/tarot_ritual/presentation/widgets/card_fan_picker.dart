import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tarot_card_back.dart';

/// A dense, curved card fan for selecting tarot cards.
///
/// Cards overlap heavily and arrange in a gentle parabolic arc.
/// Supports horizontal pan scrolling with momentum via raw pointer
/// events (Listener). Selected cards fade out and shrink, leaving
/// a subtle gap in the fan. Deselection is handled externally
/// (e.g. by tapping a position slot).
class CardFanPicker extends StatefulWidget {
  final int totalCards;
  final Set<int> selectedPositions;
  final ValueChanged<int> onCardSelected;

  const CardFanPicker({
    super.key,
    this.totalCards = 78,
    required this.selectedPositions,
    required this.onCardSelected,
  });

  @override
  State<CardFanPicker> createState() => _CardFanPickerState();
}

class _CardFanPickerState extends State<CardFanPicker>
    with SingleTickerProviderStateMixin {
  double _scrollOffset = 0.0;
  bool _initialized = false;
  AnimationController? _momentumController;

  // Pointer tracking for manual scroll via Listener
  double? _pointerStartX;
  double? _scrollStart;
  double _totalDragDx = 0.0;
  bool _isDragging = false;
  // Velocity tracking
  double _lastX = 0.0;
  Duration _lastTime = Duration.zero;
  double _velocityX = 0.0;

  double _maxScroll = 0.0;

  // Cached layout params for tap position calculation
  double? _lastViewW;
  double? _lastViewH;
  double? _lastCardW;
  double? _lastCardH;
  double? _lastSpacing;

  @override
  void dispose() {
    _momentumController?.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _momentumController?.stop();
    _pointerStartX = event.position.dx;
    _scrollStart = _scrollOffset;
    _totalDragDx = 0.0;
    _isDragging = false;
    _lastX = event.position.dx;
    _lastTime = event.timeStamp;
    _velocityX = 0.0;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerStartX == null || _scrollStart == null) return;

    final dx = event.position.dx - _pointerStartX!;
    _totalDragDx += (event.position.dx - _lastX).abs();

    // Mark as dragging once past touch slop (10px)
    if (_totalDragDx > 10) {
      _isDragging = true;
    }

    // Track velocity
    final dt = (event.timeStamp - _lastTime).inMicroseconds / 1e6;
    if (dt > 0) {
      _velocityX = (event.position.dx - _lastX) / dt;
    }
    _lastX = event.position.dx;
    _lastTime = event.timeStamp;

    setState(() {
      _scrollOffset = (_scrollStart! - dx).clamp(0.0, _maxScroll);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isDragging && _velocityX.abs() > 50) {
      _applyMomentum(-_velocityX);
    } else if (!_isDragging) {
      // Tap detected — find and select the card at this position
      _handleTapAtPosition(event.localPosition);
    }
    _pointerStartX = null;
    _scrollStart = null;
    _isDragging = false;
  }

  void _handleTapAtPosition(Offset localPos) {
    if (_lastViewW == null || _lastCardW == null) return;

    final viewW = _lastViewW!;
    final viewH = _lastViewH!;
    final cardW = _lastCardW!;
    final cardH = _lastCardH!;
    final spacing = _lastSpacing!;

    final baseY = viewH - cardH - 15;

    final firstIdx = (_scrollOffset / spacing - 3).floor().clamp(
      0,
      widget.totalCards - 1,
    );
    final lastIdx = ((_scrollOffset + viewW) / spacing + 3).ceil().clamp(
      0,
      widget.totalCards - 1,
    );

    // Check from topmost card (highest index) to bottom
    for (int i = lastIdx; i >= firstIdx; i--) {
      // Skip selected cards — they are invisible in the fan
      if (widget.selectedPositions.contains(i)) continue;

      final left = i * spacing - _scrollOffset;
      final cardCenterX = left + cardW / 2;
      final t = ((cardCenterX - viewW / 2) / (viewW / 2)).clamp(-1.5, 1.5);
      final yDrop = t * t * 20;
      final top = baseY + yDrop;

      if (localPos.dx >= left &&
          localPos.dx <= left + cardW &&
          localPos.dy >= top &&
          localPos.dy <= top + cardH) {
        HapticFeedback.selectionClick();
        widget.onCardSelected(i);
        return;
      }
    }
  }

  void _applyMomentum(double velocity) {
    _momentumController?.dispose();
    final target = (_scrollOffset + velocity * 0.25).clamp(0.0, _maxScroll);
    _momentumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final animation = Tween(begin: _scrollOffset, end: target).animate(
      CurvedAnimation(parent: _momentumController!, curve: Curves.easeOutCubic),
    );
    animation.addListener(() {
      if (mounted) setState(() => _scrollOffset = animation.value);
    });
    _momentumController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewW = constraints.maxWidth;
        final viewH = constraints.maxHeight;

        // Card sizing — responsive, fill bottom portion of fan area
        final cardH = (viewH * 0.52).clamp(140.0, 280.0);
        final cardW = cardH * 0.6;
        final spacing =
            cardW * 0.11; // dense overlap — only ~12px visible per card

        final totalContentWidth = widget.totalCards * spacing;
        _maxScroll = (totalContentWidth - viewW).clamp(0.0, double.infinity);

        // Cache for tap position calculation
        _lastViewW = viewW;
        _lastViewH = viewH;
        _lastCardW = cardW;
        _lastCardH = cardH;
        _lastSpacing = spacing;

        // Center the fan on first build
        if (!_initialized && _maxScroll > 0) {
          _scrollOffset = _maxScroll / 2;
          _initialized = true;
        }

        return Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            width: viewW,
            height: viewH,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: _buildCards(viewW, viewH, cardW, cardH, spacing),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCards(
    double viewW,
    double viewH,
    double cardW,
    double cardH,
    double spacing,
  ) {
    // Only render visible cards
    final firstIdx = (_scrollOffset / spacing - 3).floor().clamp(
      0,
      widget.totalCards - 1,
    );
    final lastIdx = ((_scrollOffset + viewW) / spacing + 3).ceil().clamp(
      0,
      widget.totalCards - 1,
    );

    // Natural order — no z-reorder for selected cards
    return [
      for (int i = firstIdx; i <= lastIdx; i++)
        _buildCard(i, viewW, viewH, cardW, cardH, spacing),
    ];
  }

  Widget _buildCard(
    int index,
    double viewW,
    double viewH,
    double cardW,
    double cardH,
    double spacing,
  ) {
    final isSelected = widget.selectedPositions.contains(index);

    // Card left-edge position
    final left = index * spacing - _scrollOffset;

    // Relative position from center of view: -1.0 to 1.0
    final cardCenterX = left + cardW / 2;
    final relPos = ((cardCenterX - viewW / 2) / (viewW / 2)).clamp(-1.5, 1.5);

    // Fan curvature: rotation + parabolic Y drop at edges
    final rotation = relPos * 0.08; // ~4.6° at edge
    final yDrop = relPos * relPos * 20; // 20px drop at edges

    // Vertical position
    final baseY = viewH - cardH - 15;

    return Positioned(
      key: ValueKey(index),
      left: left,
      top: baseY + yDrop,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 350),
        curve: isSelected ? Curves.easeInCubic : Curves.easeOutCubic,
        builder: (context, selectionT, _) {
          // Selected: fade out + shrink toward bottom center
          return Opacity(
            opacity: 1.0 - selectionT,
            child: Transform.scale(
              scale: 1.0 - selectionT * 0.3,
              alignment: Alignment.bottomCenter,
              child: Transform.rotate(
                angle: rotation,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: cardW,
                  height: cardH,
                  child: TarotCardBack(width: cardW, height: cardH),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
