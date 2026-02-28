import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);

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
              Color(0xFF0A0520),
              Color(0xFF1A0A3E),
              Color(0xFF0A0520),
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFD4AF37),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap to continue',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
