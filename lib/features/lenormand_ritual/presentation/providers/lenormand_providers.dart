import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/lenormand_session_api.dart';
import '../../data/repositories/lenormand_session_repository_impl.dart';
import '../../domain/models/lenormand_card.dart';
import '../../domain/models/lenormand_session.dart';
import '../../domain/models/lenormand_state.dart';
import '../../domain/repositories/lenormand_session_repository.dart';

// API data source
final lenormandSessionApiProvider = Provider<LenormandSessionApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return LenormandSessionApi(dioClient.dio);
});

// Repository
final lenormandSessionRepositoryProvider = Provider<LenormandSessionRepository>(
  (ref) {
    final api = ref.watch(lenormandSessionApiProvider);
    return LenormandSessionRepositoryImpl(api);
  },
);

// Session provider (fetch by ID)
final lenormandSessionProvider =
    FutureProvider.family<LenormandSession, String>((ref, sessionId) async {
      final api = ref.watch(lenormandSessionApiProvider);
      return api.getSession(sessionId);
    });

// Ritual state model
class LenormandRitualPageState {
  final LenormandSession? session;
  final LenormandRitualState step;
  final Set<int> selectedPositions;
  final int revealIndex;
  final bool isLoading;
  final String? error;

  const LenormandRitualPageState({
    this.session,
    this.step = LenormandRitualState.shuffling,
    this.selectedPositions = const {},
    this.revealIndex = 0,
    this.isLoading = false,
    this.error,
  });

  LenormandRitualPageState copyWith({
    LenormandSession? session,
    LenormandRitualState? step,
    Set<int>? selectedPositions,
    int? revealIndex,
    bool? isLoading,
    String? error,
  }) {
    return LenormandRitualPageState(
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

  List<ResolvedLenormandCard> get revealedCards {
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
class LenormandRitualNotifier extends Notifier<LenormandRitualPageState> {
  late final LenormandSessionApi _api;

  @override
  LenormandRitualPageState build() {
    _api = ref.watch(lenormandSessionApiProvider);
    return const LenormandRitualPageState();
  }

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
        revealIndex:
            session.ritualState == LenormandRitualState.completed ||
                session.ritualState == LenormandRitualState.reading
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
        ritualState: LenormandRitualState.pickingCards.value,
      );
      state = state.copyWith(
        session: session,
        step: LenormandRitualState.pickingCards,
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

  Future<void> confirmSelection() async {
    if (state.session == null || !state.selectionComplete) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: LenormandRitualState.revealing.value,
        selectedPositions: state.selectedPositions.toList()..sort(),
      );
      state = state.copyWith(
        session: session,
        step: LenormandRitualState.revealing,
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
        ritualState: LenormandRitualState.reading.value,
      );
      state = state.copyWith(
        session: session,
        step: LenormandRitualState.reading,
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
        ritualState: LenormandRitualState.cancelled.value,
      );
      state = state.copyWith(
        session: session,
        step: LenormandRitualState.cancelled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Ritual state notifier provider
final lenormandRitualProvider =
    NotifierProvider.autoDispose<
      LenormandRitualNotifier,
      LenormandRitualPageState
    >(LenormandRitualNotifier.new);
