import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

import '../theme/cosmic_colors.dart';
import '../theme/theme_provider.dart';

/// A themed loading indicator with a breathing scale + opacity animation
/// on a crescent moon icon. An optional message appears after a 2-second
/// delay to reassure the user.
class BreathingLoader extends ConsumerStatefulWidget {
  final String? message;

  const BreathingLoader({super.key, this.message});

  @override
  ConsumerState<BreathingLoader> createState() => _BreathingLoaderState();
}

class _BreathingLoaderState extends ConsumerState<BreathingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 48, end: 64).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showMessage = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = ref.watch(reducedMotionProvider);
    final l10n = AppLocalizations.of(context);
    final displayMessage =
        widget.message ?? l10n?.breathingLoaderMessage ?? '';

    if (reducedMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (reducedMotion)
          Opacity(
            opacity: 0.7,
            child: Icon(
              Icons.dark_mode,
              size: 56,
              color: CosmicColors.primary,
            ),
          )
        else
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Icon(
                  Icons.dark_mode,
                  size: _scaleAnimation.value,
                  color: CosmicColors.primary,
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: _showMessage ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          child: Text(
            displayMessage,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
