import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/chat/presentation/pages/conversation_list_page.dart';
import '../features/scenario/presentation/pages/scenario_list_page.dart';
import '../features/scenario/presentation/pages/scenario_detail_page.dart';
import '../features/settings/presentation/pages/about_character_page.dart';
import '../features/settings/presentation/pages/appearance_settings_page.dart';
import '../features/tarot_ritual/presentation/pages/spread_selection_page.dart';
import '../features/tarot_ritual/presentation/pages/tarot_ritual_page.dart';
import '../features/transit/presentation/pages/transit_list_page.dart';
import '../features/transit/presentation/pages/transit_detail_page.dart';
import '../features/transit/presentation/pages/astro_calendar_page.dart';
import '../features/mood/presentation/pages/mood_history_page.dart';
import '../features/mood/presentation/pages/mood_insights_page.dart';
import '../features/social/presentation/pages/friend_list_page.dart';
import '../features/social/presentation/pages/friend_detail_page.dart';
import '../features/social/presentation/pages/add_friend_page.dart';
import '../features/social/presentation/pages/share_preview_page.dart';
import '../features/social/domain/models/shared_card.dart';

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
      GoRoute(
        path: '/character',
        name: 'aboutCharacter',
        builder: (context, state) => const AboutCharacterPage(),
      ),
      GoRoute(
        path: '/settings/appearance',
        name: 'appearanceSettings',
        builder: (context, state) => const AppearanceSettingsPage(),
      ),
      GoRoute(
        path: '/tarot/spread-select',
        name: 'tarotSpreadSelect',
        builder: (context, state) {
          final conversationId =
              state.uri.queryParameters['conversation_id'] ?? '';
          return SpreadSelectionPage(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: '/tarot/ritual/:sessionId',
        name: 'tarotRitual',
        builder: (context, state) => TarotRitualPage(
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),
      GoRoute(
        path: '/mood/history',
        name: 'moodHistory',
        builder: (context, state) => const MoodHistoryPage(),
      ),
      GoRoute(
        path: '/mood/insights',
        name: 'moodInsights',
        builder: (context, state) => const MoodInsightsPage(),
      ),
      GoRoute(
        path: '/friends',
        name: 'friendList',
        builder: (context, state) => const FriendListPage(),
      ),
      GoRoute(
        path: '/friends/add',
        name: 'addFriend',
        builder: (context, state) => const AddFriendPage(),
      ),
      GoRoute(
        path: '/friends/:id',
        name: 'friendDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FriendDetailPage(friendId: id);
        },
      ),
      GoRoute(
        path: '/share/preview',
        name: 'sharePreview',
        builder: (context, state) {
          final card = state.extra as SharedCard;
          return SharePreviewPage(card: card);
        },
      ),
    ],
  );
});
