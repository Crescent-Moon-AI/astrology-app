import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/scenario_api.dart';
import '../../data/repositories/scenario_repository_impl.dart';
import '../../domain/models/scenario.dart';
import '../../domain/repositories/scenario_repository.dart';

// API data source
final scenarioApiProvider = Provider<ScenarioApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ScenarioApi(dioClient.dio);
});

// Repository
final scenarioRepositoryProvider = Provider<ScenarioRepository>((ref) {
  final api = ref.watch(scenarioApiProvider);
  return ScenarioRepositoryImpl(api);
});

// Categories
final scenarioCategoriesProvider =
    FutureProvider<List<ScenarioCategory>>((ref) async {
  final repo = ref.watch(scenarioRepositoryProvider);
  return repo.listCategories();
});

// Selected category filter
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
        SelectedCategoryNotifier.new);

// Scenario list (filtered by category)
final scenarioListProvider = FutureProvider<List<Scenario>>((ref) async {
  final repo = ref.watch(scenarioRepositoryProvider);
  final categorySlug = ref.watch(selectedCategoryProvider);
  return repo.listScenarios(categorySlug: categorySlug);
});

// Hot scenarios for chat empty state
final hotScenariosProvider =
    FutureProvider<List<ScenarioSummary>>((ref) async {
  final repo = ref.watch(scenarioRepositoryProvider);
  return repo.listHotScenarios();
});

// Single scenario detail
final scenarioDetailProvider =
    FutureProvider.family<Scenario?, String>((ref, id) async {
  final repo = ref.watch(scenarioRepositoryProvider);
  return repo.getScenario(id);
});
