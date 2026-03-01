import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../theme/cosmic_colors.dart';
import '../theme/theme_provider.dart';

/// A mystical-themed loading indicator with breathing circle animation
/// and rotating poetic messages. Respects reduced-motion settings.
class MysticalLoadingWidget extends ConsumerStatefulWidget {
  const MysticalLoadingWidget({super.key});

  @override
  ConsumerState<MysticalLoadingWidget> createState() =>
      _MysticalLoadingWidgetState();
}

class _MysticalLoadingWidgetState extends ConsumerState<MysticalLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _glowAnimation;
  int _messageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 48,
      end: 72,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glowAnimation = Tween<double>(
      begin: 16,
      end: 36,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _messageTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() => _messageIndex = (_messageIndex + 1) % 4);
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  List<String> _getMessages(AppLocalizations l10n) {
    return [
      l10n.mysticalLoading1,
      l10n.mysticalLoading2,
      l10n.mysticalLoading3,
      l10n.mysticalLoading4,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = ref.watch(reducedMotionProvider);
    final l10n = AppLocalizations.of(context)!;
    final messages = _getMessages(l10n);

    if (reducedMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (reducedMotion)
          _buildStaticIcon()
        else
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CosmicColors.primary.withAlpha(
                        (_opacityAnimation.value * 51).round(),
                      ),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Icon(
                      Icons.auto_awesome,
                      size: _scaleAnimation.value,
                      color: CosmicColors.primaryLight,
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 28),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: Text(
            messages[_messageIndex],
            key: ValueKey<int>(_messageIndex),
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStaticIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primary.withAlpha(38),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Center(
        child: Opacity(
          opacity: 0.7,
          child: Icon(
            Icons.auto_awesome,
            size: 48,
            color: CosmicColors.primary,
          ),
        ),
      ),
    );
  }
}
