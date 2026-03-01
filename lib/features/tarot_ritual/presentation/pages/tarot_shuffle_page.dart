import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/shuffle_animation.dart';

class TarotShufflePage extends ConsumerStatefulWidget {
  const TarotShufflePage({super.key});

  @override
  ConsumerState<TarotShufflePage> createState() => _TarotShufflePageState();
}

class _TarotShufflePageState extends ConsumerState<TarotShufflePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // Auto-advance after 3 seconds
    _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(tarotRitualProvider.notifier).advanceShuffle();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    return GestureDetector(
      onTap: () {
        _autoAdvanceTimer?.cancel();
        ref.read(tarotRitualProvider.notifier).advanceShuffle();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CosmicColors.background,
              Color(0xFF1A0A3E),
              CosmicColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShuffleAnimation(),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeController,
                child: Text(
                  l10n.tarotShuffling,
                  style: const TextStyle(
                    color: CosmicColors.secondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isZh ? '轻触继续' : 'Tap to continue',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
