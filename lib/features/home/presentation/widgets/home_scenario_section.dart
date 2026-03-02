import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../scenario/presentation/providers/scenario_providers.dart';
import '../../../scenario/presentation/widgets/scenario_card.dart';

class HomeScenarioSection extends ConsumerWidget {
  const HomeScenarioSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scenariosAsync = ref.watch(scenarioListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.homeSceneExplore,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/scenarios'),
                child: Text(
                  l10n.homeExploreMore,
                  style: const TextStyle(
                    color: CosmicColors.primaryLight,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Scenario cards
          scenariosAsync.when(
            data: (scenarios) {
              final display = scenarios.take(4).toList();
              return Column(
                children: display.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ScenarioCard(
                      scenario: s,
                      onTap: () => context.push('/scenarios/${s.id}'),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: CosmicColors.primaryLight,
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
