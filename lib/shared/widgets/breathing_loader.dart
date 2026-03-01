import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

import '../theme/cosmic_colors.dart';
import '../theme/theme_provider.dart';

/// A themed loading indicator with a breathing scale + opacity animation
/// on a crescent moon icon surrounded by a glow circle. Shows breathing
/// phase text ("inhale" / "exhale") and a poetic message after delay.
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
  late final Animation<double> _glowAnimation;
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 56,
      end: 80,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glowAnimation = Tween<double>(
      begin: 20,
      end: 40,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final displayMessage =
        widget.message ??
        (isZh
            ? '\u5B87\u5B99\u7684\u8BAF\u606F\u6B63\u5728\u6C47\u805A...'
            : l10n?.breathingLoaderMessage ?? '');

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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Large glow circle behind icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CosmicColors.primary.withAlpha(
                            (_opacityAnimation.value * 51).round(),
                          ), // 20%
                          blurRadius: _glowAnimation.value,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Icon(
                          Icons.dark_mode,
                          size: _scaleAnimation.value,
                          color: CosmicColors.primaryLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Breathing phase text
                  Text(
                    _controller.value < 0.5
                        ? (isZh ? '\u5438\u6C14...' : 'Inhale...')
                        : (isZh ? '\u547C\u6C14...' : 'Exhale...'),
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 24),
        AnimatedOpacity(
          opacity: _showMessage ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          child: Text(
            displayMessage,
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
      width: 80,
      height: 80,
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
      child: Center(
        child: Opacity(
          opacity: 0.7,
          child: Icon(Icons.dark_mode, size: 56, color: CosmicColors.primary),
        ),
      ),
    );
  }
}
