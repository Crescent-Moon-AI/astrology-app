import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/tarot_session_api.dart';
import '../../data/repositories/tarot_session_repository_impl.dart';
import '../../domain/models/ritual_state.dart';
import '../../domain/models/tarot_card.dart';
import '../../domain/models/tarot_session.dart';
import '../../domain/repositories/tarot_session_repository.dart';

// API data source
final tarotSessionApiProvider = Provider<TarotSessionApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TarotSessionApi(dioClient.dio);
});

// Repository
final tarotSessionRepositoryProvider =
    Provider<TarotSessionRepository>((ref) {
  final api = ref.watch(tarotSessionApiProvider);
  return TarotSessionRepositoryImpl(api);
});

// Session provider (fetch by ID)
final tarotSessionProvider =
    FutureProvider.family<TarotSession, String>((ref, sessionId) async {
  final api = ref.watch(tarotSessionApiProvider);
  return api.getSession(sessionId);
});

// Sessions list (by conversation ID)
final tarotSessionsListProvider =
    FutureProvider.family<List<TarotSession>, String>(
        (ref, conversationId) async {
  final api = ref.watch(tarotSessionApiProvider);
  return api.listSessions(conversationId);
});

// Ritual state model
class TarotRitualState {
  final TarotSession? session;
  final RitualState step;
  final Set<int> selectedPositions;
  final int revealIndex;
  final bool isLoading;
  final String? error;

  const TarotRitualState({
    this.session,
    this.step = RitualState.shuffling,
    this.selectedPositions = const {},
    this.revealIndex = 0,
    this.isLoading = false,
    this.error,
  });

  TarotRitualState copyWith({
    TarotSession? session,
    RitualState? step,
    Set<int>? selectedPositions,
    int? revealIndex,
    bool? isLoading,
    String? error,
  }) {
    return TarotRitualState(
      session: session ?? this.session,
      step: step ?? this.step,
      selectedPositions: selectedPositions ?? this.selectedPositions,
      revealIndex: revealIndex ?? this.revealIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get totalCards => session?.cardCount ?? 0;

  bool get canSelectMore => selectedPositions.length < totalCards;

  bool get selectionComplete => selectedPositions.length == totalCards;

  List<ResolvedCard> get revealedCards {
    final cards = session?.selectedCards;
    if (cards == null) return [];
    return cards.take(revealIndex).toList();
  }

  bool get allRevealed {
    final cards = session?.selectedCards;
    if (cards == null) return false;
    return revealIndex >= cards.length;
  }
}

// Ritual state notifier
class TarotRitualNotifier extends StateNotifier<TarotRitualState> {
  final TarotSessionApi _api;

  TarotRitualNotifier(this._api) : super(const TarotRitualState());

  Future<void> createSession({
    required String conversationId,
    required String spreadType,
    String? question,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.createSession(
        conversationId: conversationId,
        spreadType: spreadType,
        question: question,
      );
      state = state.copyWith(
        session: session,
        step: session.ritualState,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.getSession(sessionId);
      state = state.copyWith(
        session: session,
        step: session.ritualState,
        selectedPositions: session.selectedPositions.toSet(),
        revealIndex: session.ritualState == RitualState.completed ||
                session.ritualState == RitualState.reading
            ? session.selectedCards?.length ?? 0
            : 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> advanceShuffle() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RitualState.pickingCards.value,
      );
      state = state.copyWith(
        session: session,
        step: RitualState.pickingCards,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectCard(int position) {
    if (!state.canSelectMore && !state.selectedPositions.contains(position)) {
      return;
    }
    final updated = Set<int>.from(state.selectedPositions);
    if (updated.contains(position)) {
      updated.remove(position);
    } else {
      updated.add(position);
    }
    state = state.copyWith(selectedPositions: updated);
  }

  void deselectCard(int position) {
    final updated = Set<int>.from(state.selectedPositions)..remove(position);
    state = state.copyWith(selectedPositions: updated);
  }

  Future<void> confirmSelection() async {
    if (state.session == null || !state.selectionComplete) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RitualState.revealing.value,
        selectedPositions: state.selectedPositions.toList()..sort(),
      );
      state = state.copyWith(
        session: session,
        step: RitualState.revealing,
        revealIndex: 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void revealNextCard() {
    if (state.allRevealed) return;
    state = state.copyWith(revealIndex: state.revealIndex + 1);
  }

  Future<void> startReading() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RitualState.reading.value,
      );
      state = state.copyWith(
        session: session,
        step: RitualState.reading,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> cancel() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RitualState.cancelled.value,
      );
      state = state.copyWith(
        session: session,
        step: RitualState.cancelled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Ritual state notifier provider
final tarotRitualProvider =
    StateNotifierProvider.autoDispose<TarotRitualNotifier, TarotRitualState>(
        (ref) {
  final api = ref.watch(tarotSessionApiProvider);
  return TarotRitualNotifier(api);
});
