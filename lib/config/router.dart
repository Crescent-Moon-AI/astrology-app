import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/chat/presentation/pages/conversation_list_page.dart';
import '../features/consult/presentation/pages/consult_page.dart';
import '../features/diary/presentation/pages/diary_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/insight/presentation/pages/insight_page.dart';
import '../features/scenario/presentation/pages/scenario_list_page.dart';
import '../features/scenario/presentation/pages/scenario_detail_page.dart';
import '../features/settings/presentation/pages/about_character_page.dart';
import '../features/settings/presentation/pages/appearance_settings_page.dart';
import '../features/settings/presentation/pages/edit_birth_data_page.dart';
import '../features/settings/presentation/pages/profile_page.dart';
import '../features/shell/main_shell_page.dart';
import '../features/tarot_ritual/presentation/pages/spread_selection_page.dart';
import '../features/tarot_ritual/presentation/pages/tarot_ritual_page.dart';
import '../features/dice_ritual/presentation/pages/dice_ritual_page.dart';
import '../features/numerology/presentation/pages/numerology_input_page.dart';
import '../features/rune_ritual/presentation/pages/rune_spread_select.dart';
import '../features/rune_ritual/presentation/pages/rune_ritual_page.dart';
import '../features/lenormand_ritual/presentation/pages/lenormand_spread_select.dart';
import '../features/lenormand_ritual/presentation/pages/lenormand_ritual_page.dart';
import '../features/iching_ritual/presentation/pages/iching_question_page.dart';
import '../features/iching_ritual/presentation/pages/iching_ritual_page.dart';
import '../features/meihua_ritual/presentation/pages/meihua_method_page.dart';
import '../features/divination/presentation/pages/divination_hub_page.dart';
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
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main shell with bottom navigation — 5 tabs
      ShellRoute(
        builder: (context, state, child) => MainShellPage(child: child),
        routes: [
          // Tab 0: Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),

          // Tab 1: Insight
          GoRoute(
            path: '/insight',
            name: 'insight',
            builder: (context, state) => const InsightPage(),
          ),

          // Tab 2: Consult (center button)
          GoRoute(
            path: '/consult',
            name: 'consult',
            builder: (context, state) => const ConsultPage(),
          ),

          // Tab 3: Diary
          GoRoute(
            path: '/diary',
            name: 'diary',
            builder: (context, state) => const DiaryPage(),
          ),

          // Tab 4: Profile
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Full-screen routes (no bottom navigation)
      GoRoute(
        path: '/scenarios',
        name: 'scenarios',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const ScenarioListPage()),
      ),
      GoRoute(
        path: '/scenarios/:id',
        name: 'scenarioDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _cosmicFadePage(state, ScenarioDetailPage(scenarioId: id));
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
        pageBuilder: (context, state) => _cosmicFadePage(
          state,
          ChatPage(
            scenarioId: state.uri.queryParameters['scenario_id'],
            initialMessage: state.uri.queryParameters['initial_message'],
            tarotSessionId: state.uri.queryParameters['tarot_session_id'],
          ),
        ),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chatConversation',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _cosmicFadePage(
            state,
            ChatPage(
              conversationId: id,
              tarotSessionId: state.uri.queryParameters['tarot_session_id'],
            ),
          );
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
        path: '/settings/birth-data',
        name: 'editBirthData',
        builder: (context, state) => const EditBirthDataPage(),
      ),
      GoRoute(
        path: '/tarot',
        name: 'tarot',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const SpreadSelectionPage()),
      ),
      GoRoute(
        path: '/tarot/spread-select',
        name: 'tarotSpreadSelect',
        pageBuilder: (context, state) {
          final conversationId = state.uri.queryParameters['conversation_id'];
          return _cosmicFadePage(
            state,
            SpreadSelectionPage(conversationId: conversationId),
          );
        },
      ),
      GoRoute(
        path: '/tarot/ritual/:sessionId',
        name: 'tarotRitual',
        pageBuilder: (context, state) => _cosmicFadePage(
          state,
          TarotRitualPage(sessionId: state.pathParameters['sessionId']!),
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

      // Divination Hub
      GoRoute(
        path: '/divination',
        name: 'divination',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const DivinationHubPage()),
      ),

      // Dice Ritual
      GoRoute(
        path: '/dice',
        name: 'dice',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const DiceRitualPage()),
      ),

      // Numerology
      GoRoute(
        path: '/numerology',
        name: 'numerology',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const NumerologyInputPage()),
      ),

      // Rune Ritual
      GoRoute(
        path: '/rune',
        name: 'rune',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const RuneSpreadSelect()),
      ),
      GoRoute(
        path: '/rune/ritual/:sessionId',
        name: 'runeRitual',
        pageBuilder: (context, state) => _cosmicFadePage(
          state,
          RuneRitualPage(sessionId: state.pathParameters['sessionId']!),
        ),
      ),

      // Lenormand Ritual
      GoRoute(
        path: '/lenormand',
        name: 'lenormand',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const LenormandSpreadSelect()),
      ),
      GoRoute(
        path: '/lenormand/ritual/:sessionId',
        name: 'lenormandRitual',
        pageBuilder: (context, state) => _cosmicFadePage(
          state,
          LenormandRitualPage(sessionId: state.pathParameters['sessionId']!),
        ),
      ),

      // I Ching Ritual
      GoRoute(
        path: '/iching',
        name: 'iching',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const IChingQuestionPage()),
      ),
      GoRoute(
        path: '/iching/ritual/:sessionId',
        name: 'ichingRitual',
        pageBuilder: (context, state) => _cosmicFadePage(
          state,
          IChingRitualPage(sessionId: state.pathParameters['sessionId']!),
        ),
      ),

      // Meihua Ritual
      GoRoute(
        path: '/meihua',
        name: 'meihua',
        pageBuilder: (context, state) =>
            _cosmicFadePage(state, const MeihuaMethodPage()),
      ),
    ],
  );
});

/// Cosmic fade transition for full-screen immersive routes.
CustomTransitionPage<void> _cosmicFadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
