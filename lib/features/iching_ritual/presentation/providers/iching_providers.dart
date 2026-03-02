import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/iching_session_api.dart';
import '../../data/repositories/iching_session_repository_impl.dart';
import '../../domain/models/coin_toss.dart';
import '../../domain/models/iching_session.dart';
import '../../domain/models/iching_state.dart';
import '../../domain/repositories/iching_session_repository.dart';

// API data source
final ichingSessionApiProvider = Provider<IChingSessionApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return IChingSessionApi(dioClient.dio);
});

// Repository
final ichingSessionRepositoryProvider = Provider<IChingSessionRepository>((
  ref,
) {
  final api = ref.watch(ichingSessionApiProvider);
  return IChingSessionRepositoryImpl(api);
});

// Session provider (fetch by ID)
final ichingSessionProvider = FutureProvider.family<IChingSession, String>((
  ref,
  sessionId,
) async {
  final api = ref.watch(ichingSessionApiProvider);
  return api.getSession(sessionId);
});

// Ritual state model
class IChingRitualPageState {
  final IChingSession? session;
  final IChingRitualState step;
  final List<CoinToss> localTosses;
  final int currentRound; // 0-5
  final bool isLoading;
  final String? error;

  const IChingRitualPageState({
    this.session,
    this.step = IChingRitualState.question,
    this.localTosses = const [],
    this.currentRound = 0,
    this.isLoading = false,
    this.error,
  });

  IChingRitualPageState copyWith({
    IChingSession? session,
    IChingRitualState? step,
    List<CoinToss>? localTosses,
    int? currentRound,
    bool? isLoading,
    String? error,
  }) {
    return IChingRitualPageState(
      session: session ?? this.session,
      step: step ?? this.step,
      localTosses: localTosses ?? this.localTosses,
      currentRound: currentRound ?? this.currentRound,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get allTossesComplete => localTosses.length >= 6;
}

// Ritual state notifier
class IChingRitualNotifier extends Notifier<IChingRitualPageState> {
  late final IChingSessionApi _api;

  @override
  IChingRitualPageState build() {
    _api = ref.watch(ichingSessionApiProvider);
    return const IChingRitualPageState();
  }

  Future<void> createSession({
    required String conversationId,
    String? question,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.createSession(
        conversationId: conversationId,
        question: question,
      );
      state = state.copyWith(
        session: session,
        step: IChingRitualState.tossing,
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
        localTosses: session.tosses,
        currentRound: session.tosses.length,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  CoinToss tossCoin() {
    final random = Random();
    final coins = List.generate(3, (_) => random.nextBool());
    final toss = CoinToss.fromCoins(coins);

    final updatedTosses = [...state.localTosses, toss];
    state = state.copyWith(
      localTosses: updatedTosses,
      currentRound: updatedTosses.length,
    );

    return toss;
  }

  Future<void> finishTossing() async {
    if (state.session == null || !state.allTossesComplete) return;
    state = state.copyWith(
      step: IChingRitualState.building,
      isLoading: true,
      error: null,
    );
    try {
      final tossData = state.localTosses
          .map((t) => {'coins': t.coins, 'sum': t.sum})
          .toList();
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: IChingRitualState.revealing.value,
        tosses: tossData,
      );
      state = state.copyWith(
        session: session,
        step: IChingRitualState.revealing,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> startReading() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _api.updateSession(
        state.session!.id,
        ritualState: IChingRitualState.reading.value,
      );
      state = state.copyWith(
        session: session,
        step: IChingRitualState.reading,
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
        ritualState: IChingRitualState.cancelled.value,
      );
      state = state.copyWith(
        session: session,
        step: IChingRitualState.cancelled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Ritual state notifier provider
final ichingRitualProvider =
    NotifierProvider.autoDispose<IChingRitualNotifier, IChingRitualPageState>(
      IChingRitualNotifier.new,
    );
