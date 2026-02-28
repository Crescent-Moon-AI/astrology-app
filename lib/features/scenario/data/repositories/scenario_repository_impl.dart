import '../../domain/models/scenario.dart';
import '../../domain/repositories/scenario_repository.dart';
import '../datasources/scenario_api.dart';

class ScenarioRepositoryImpl implements ScenarioRepository {
  final ScenarioApi _api;

  ScenarioRepositoryImpl(this._api);

  @override
  Future<List<Scenario>> listScenarios({
    String? categorySlug,
    int limit = 20,
    String? cursor,
  }) async {
    final data = await _api.listScenarios(
      categorySlug: categorySlug,
      limit: limit,
      cursor: cursor,
    );
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Scenario?> getScenario(String id) async {
    final data = await _api.getScenario(id);
    return Scenario.fromJson(data);
  }

  @override
  Future<List<ScenarioCategory>> listCategories() async {
    final data = await _api.listCategories();
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => ScenarioCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ScenarioSummary>> listHotScenarios() async {
    final data = await _api.listHotScenarios();
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => ScenarioSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
