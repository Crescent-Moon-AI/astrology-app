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
        backgroundColor: CosmicColors.background,
        elevation: 0,
        title: Text(
          l10n.scenarioExploreTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CosmicColors.textPrimary,
          ),
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
                  ref.read(selectedCategoryProvider.notifier).state = slug;
                },
              ),
              loading: () => const SizedBox(height: 48),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Scenario grid
            Expanded(
              child: scenariosAsync.when(
                data: (scenarios) => _buildGrid(context, scenarios),
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
                        'Failed to load scenarios',
                        style: TextStyle(color: CosmicColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(scenarioListProvider);
                          ref.invalidate(scenarioCategoriesProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
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

  Widget _buildGrid(BuildContext context, List<Scenario> scenarios) {
    if (scenarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('\uD83C\uDF0C', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'No scenarios found',
              style: TextStyle(color: CosmicColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: scenarios.length,
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
