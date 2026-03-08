import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/scenario.dart';
import '../providers/scenario_providers.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/scenario_card.dart';

class ScenarioListPage extends ConsumerWidget {
  const ScenarioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(scenarioCategoriesProvider);
    final scenariosAsync = ref.watch(scenarioListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.scenarioExploreTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CosmicColors.textPrimary,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  CosmicColors.primaryLight,
                  CosmicColors.secondaryLight,
                ],
              ).createShader(bounds),
              child: Text(
                l10n.scenarioExploreSubline,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}, // TODO: search
          ),
        ],
      ),
      body: StarfieldBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category filter chips
            categoriesAsync.when(
              data: (categories) => CategoryFilterChips(
                categories: categories,
                onSelected: (slug) {
                  ref.read(selectedCategoryProvider.notifier).set(slug);
                },
              ),
              loading: () => const SizedBox(height: 48),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Scenario list
            Expanded(
              child: scenariosAsync.when(
                data: (scenarios) => _buildList(context, l10n, scenarios),
                loading: () => const Center(child: BreathingLoader()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off,
                        size: 48,
                        color: CosmicColors.textTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.scenarioLoadFailed,
                        style: TextStyle(color: CosmicColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(scenarioListProvider);
                          ref.invalidate(scenarioCategoriesProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retry),
                        style: TextButton.styleFrom(
                          foregroundColor: CosmicColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, AppLocalizations l10n, List<Scenario> scenarios) {
    if (scenarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('\uD83C\uDF0C', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              l10n.scenarioNoneFound,
              style: TextStyle(color: CosmicColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: scenarios.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return ScenarioCard(
          scenario: scenario,
          onTap: () => context.pushNamed(
            'scenarioDetail',
            pathParameters: {'id': scenario.id},
          ),
        );
      },
    );
  }
}
