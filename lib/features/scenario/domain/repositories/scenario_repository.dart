import '../models/scenario.dart';

abstract class ScenarioRepository {
  Future<List<Scenario>> listScenarios({
    String? categorySlug,
    int limit = 20,
    String? cursor,
  });

  Future<Scenario?> getScenario(String id);

  Future<List<ScenarioCategory>> listCategories();

  Future<List<ScenarioSummary>> listHotScenarios();
}
