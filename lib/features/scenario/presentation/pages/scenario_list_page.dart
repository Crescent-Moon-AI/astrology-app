import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
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
        title: Text(l10n.scenarioExploreTitle),
      ),
      body: Column(
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
            loading: () => const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Scenario grid
          Expanded(
            child: scenariosAsync.when(
              data: (scenarios) => _buildGrid(context, scenarios),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Scenario> scenarios) {
    if (scenarios.isEmpty) {
      return const Center(
        child: Text('No scenarios found'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
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
