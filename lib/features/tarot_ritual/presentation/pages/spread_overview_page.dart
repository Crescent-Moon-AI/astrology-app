import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/spread_type.dart';
import '../providers/tarot_ritual_providers.dart';
import '../widgets/spread_layout_widget.dart';

class SpreadOverviewPage extends ConsumerWidget {
  const SpreadOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(tarotRitualProvider);
    final session = ritualState.session;

    if (session == null) {
      return const Center(
        child: CircularProgressIndicator(color: CosmicColors.secondary),
      );
    }

    final spreadType = SpreadType.fromValue(session.spreadType);
    final cards = session.selectedCards ?? [];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CosmicColors.background,
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
                    style: const TextStyle(
                      color: CosmicColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (session.question.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '"${session.question}"',
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 14,
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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: CosmicColors.primaryGradient,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ritualState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(tarotRitualProvider.notifier)
                                  .startReading();
                            },
                      borderRadius: BorderRadius.circular(26),
                      child: Center(
                        child: ritualState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.tarotBeginReading,
                                style: const TextStyle(
                                  color: CosmicColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
