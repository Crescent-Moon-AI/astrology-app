import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/chat/presentation/pages/conversation_list_page.dart';
import '../features/scenario/presentation/pages/scenario_list_page.dart';
import '../features/scenario/presentation/pages/scenario_detail_page.dart';
import '../features/transit/presentation/pages/transit_list_page.dart';
import '../features/transit/presentation/pages/transit_detail_page.dart';
import '../features/transit/presentation/pages/astro_calendar_page.dart';

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
      GoRoute(
        path: '/conversations',
        name: 'conversations',
        builder: (context, state) => const ConversationListPage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => ChatPage(
          scenarioId: state.uri.queryParameters['scenario_id'],
        ),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chatConversation',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChatPage(conversationId: id);
        },
      ),
      GoRoute(
        path: '/transits',
        name: 'transits',
        builder: (context, state) => const TransitListPage(),
      ),
      GoRoute(
        path: '/transits/:id',
        name: 'transitDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransitDetailPage(transitAlertId: id);
        },
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const AstroCalendarPage(),
      ),
    ],
  );
});
