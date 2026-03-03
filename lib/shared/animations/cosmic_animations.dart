import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Extension methods on [Widget] providing reusable cosmic-themed animations.
///
/// All animations are built on top of `flutter_animate`. When the global
/// [Animate.defaultDuration] is set to [Duration.zero] (reduced-motion mode),
/// these effectively become no-ops.
extension CosmicAnimations on Widget {
  /// Fade-in with a subtle scale-up entrance.
  Widget cosmicFadeIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: Curves.easeOut,
        );
  }

  /// Looping shimmer (opacity pulse) for ambient sparkle effects.
  Widget cosmicShimmer({
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return animate(
      onPlay: (c) => c.repeat(reverse: true),
    ).fadeIn(begin: 0.5, duration: duration, curve: Curves.easeInOut);
  }

  /// Slide up from below with fade — great for list item stagger.
  Widget cosmicSlideUp({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(begin: 0.15, end: 0, duration: duration, curve: Curves.easeOut);
  }
}
