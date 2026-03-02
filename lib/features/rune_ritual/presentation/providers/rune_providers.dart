import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/rune_session_api.dart';
import '../../data/repositories/rune_session_repository_impl.dart';
import '../../domain/models/rune_card.dart';
import '../../domain/models/rune_session.dart';
import '../../domain/models/rune_state.dart';
import '../../domain/repositories/rune_session_repository.dart';

// API data source
final runeSessionApiProvider = Provider<RuneSessionApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RuneSessionApi(dioClient.dio);
});

// Repository
final runeSessionRepositoryProvider = Provider<RuneSessionRepository>((ref) {
  final api = ref.watch(runeSessionApiProvider);
  return RuneSessionRepositoryImpl(api);
});

// Session provider (fetch by ID)
final runeSessionProvider = FutureProvider.family<RuneSession, String>((
  ref,
  sessionId,
) async {
  final api = ref.watch(runeSessionApiProvider);
  return api.getSession(sessionId);
});

// Ritual state model
class RuneRitualPageState {
  final RuneSession? session;
  final RuneRitualState step;
  final int revealIndex;
  final bool isLoading;
  final String? error;

  const RuneRitualPageState({
    this.session,
    this.step = RuneRitualState.selectSpread,
    this.revealIndex = 0,
    this.isLoading = false,
    this.error,
  });

  RuneRitualPageState copyWith({
    RuneSession? session,
    RuneRitualState? step,
    int? revealIndex,
    bool? isLoading,
    String? error,
  }) {
    return RuneRitualPageState(
      session: session ?? this.session,
      step: step ?? this.step,
      revealIndex: revealIndex ?? this.revealIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<RuneDefinition> get revealedRunes {
    final runes = session?.drawnRunes;
    if (runes == null) return [];
    return runes.take(revealIndex).toList();
  }

  bool get allRevealed {
    final runes = session?.drawnRunes;
    if (runes == null) return false;
    return revealIndex >= runes.length;
  }
}

// Ritual state notifier
class RuneRitualNotifier extends Notifier<RuneRitualPageState> {
  late final RuneSessionApi _api;

  @override
  RuneRitualPageState build() {
    _api = ref.watch(runeSessionApiProvider);
    return const RuneRitualPageState();
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
        revealIndex:
            session.ritualState == RuneRitualState.completed ||
                session.ritualState == RuneRitualState.reading
            ? session.drawnRunes?.length ?? 0
            : 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> advanceDrawing() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RuneRitualState.revealing.value,
      );
      state = state.copyWith(
        session: session,
        step: RuneRitualState.revealing,
        revealIndex: 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void revealNextRune() {
    if (state.allRevealed) return;
    state = state.copyWith(revealIndex: state.revealIndex + 1);
  }

  Future<void> startReading() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: RuneRitualState.reading.value,
      );
      state = state.copyWith(
        session: session,
        step: RuneRitualState.reading,
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
        ritualState: RuneRitualState.cancelled.value,
      );
      state = state.copyWith(
        session: session,
        step: RuneRitualState.cancelled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Ritual state notifier provider
final runeRitualProvider =
    NotifierProvider.autoDispose<RuneRitualNotifier, RuneRitualPageState>(
      RuneRitualNotifier.new,
    );
