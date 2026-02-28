import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/scenario/presentation/pages/scenario_list_page.dart';
import '../features/scenario/presentation/pages/scenario_detail_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/scenarios',
    routes: [
      GoRoute(
        path: '/scenarios',
        name: 'scenarios',
        builder: (context, state) => const ScenarioListPage(),
      ),
      GoRoute(
        path: '/scenarios/:id',
        name: 'scenarioDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ScenarioDetailPage(scenarioId: id);
        },
      ),
    ],
  );
});
