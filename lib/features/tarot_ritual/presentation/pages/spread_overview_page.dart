import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../domain/models/spread_type.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/spread_layout_widget.dart';

class SpreadOverviewPage extends ConsumerWidget {
  const SpreadOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final ritualState = ref.watch(tarotRitualProvider);
    final session = ritualState.session;

    if (session == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final spreadType = SpreadType.fromValue(session.spreadType);
    final cards = session.selectedCards ?? [];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0520),
            Color(0xFF1A0A3E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    l10n.tarotReadingComplete,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (session.question.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '"${session.question}"',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Spread layout
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SpreadLayoutWidget(
                    spreadType: spreadType,
                    cards: cards,
                    positionLabels: session.positionLabels,
                    revealedCount: cards.length,
                  ),
                ),
              ),
            ),

            // Begin reading button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: ritualState.isLoading
                      ? null
                      : () {
                          ref
                              .read(tarotRitualProvider.notifier)
                              .startReading();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                  ),
                  child: ritualState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.tarotBeginReading),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
