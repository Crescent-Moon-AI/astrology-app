import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/moon_phase_provider.dart';
import '../theme/cosmic_colors.dart';

/// Displays the current moon phase emoji with a tooltip showing the
/// phase name. Data is fetched via [moonPhaseProvider].
class MoonPhaseWidget extends ConsumerWidget {
  final double size;

  const MoonPhaseWidget({super.key, this.size = 32});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moonPhaseAsync = ref.watch(moonPhaseProvider);

    return moonPhaseAsync.when(
      data: (moonPhase) => Tooltip(
        message: moonPhase.phaseName,
        child: Text(
          moonPhase.emoji,
          style: TextStyle(fontSize: size),
        ),
      ),
      loading: () => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => Icon(
        Icons.dark_mode,
        size: size,
        color: CosmicColors.textTertiary,
      ),
    );
  }
}
