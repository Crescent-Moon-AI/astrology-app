import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dice_result.dart';
import '../../domain/models/dice_state.dart';

class DiceRitualState {
  final String question;
  final DiceResult? diceResult;
  final DiceState step;
  final bool isLoading;
  final String? error;

  const DiceRitualState({
    this.question = '',
    this.diceResult,
    this.step = DiceState.idle,
    this.isLoading = false,
    this.error,
  });

  DiceRitualState copyWith({
    String? question,
    DiceResult? diceResult,
    DiceState? step,
    bool? isLoading,
    String? error,
  }) {
    return DiceRitualState(
      question: question ?? this.question,
      diceResult: diceResult ?? this.diceResult,
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DiceRitualNotifier extends Notifier<DiceRitualState> {
  @override
  DiceRitualState build() {
    return const DiceRitualState();
  }

  void setQuestion(String question) {
    state = state.copyWith(question: question);
  }

  Future<void> rollDice() async {
    state = state.copyWith(
      step: DiceState.rolling,
      isLoading: true,
      error: null,
    );

    // Simulate rolling delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final random = Random();
    final dice = List.generate(3, (_) => random.nextInt(6) + 1);
    final total = dice.fold<int>(0, (sum, d) => sum + d);

    // Local meaning based on total
    final meanings = _getMeaning(total);

    final result = DiceResult(
      dice: dice,
      total: total,
      meaning: meanings['en']!,
      meaningZh: meanings['zh']!,
    );

    state = state.copyWith(
      diceResult: result,
      step: DiceState.revealed,
      isLoading: false,
    );
  }

  void startReading() {
    state = state.copyWith(step: DiceState.reading);
  }

  void reset() {
    state = const DiceRitualState();
  }

  Map<String, String> _getMeaning(int total) {
    if (total <= 5) {
      return {
        'en': 'A time of reflection and patience. Wait for the right moment.',
        'zh': '这是一个反思与耐心的时刻。等待合适的时机。',
      };
    } else if (total <= 8) {
      return {
        'en': 'Steady progress ahead. Trust the process and stay grounded.',
        'zh': '前方稳步前进。相信过程，保持脚踏实地。',
      };
    } else if (total <= 11) {
      return {
        'en':
            'Balance and harmony surround you. A favorable period for decisions.',
        'zh': '平衡与和谐环绕着你。这是做决定的有利时期。',
      };
    } else if (total <= 14) {
      return {
        'en':
            'Strong positive energy flows. Seize opportunities with confidence.',
        'zh': '强大的正能量在流动。充满信心地抓住机遇。',
      };
    } else {
      return {
        'en': 'Exceptional fortune awaits. Bold actions will be rewarded.',
        'zh': '非凡的好运在等待着你。大胆的行动将会得到回报。',
      };
    }
  }
}

final diceRitualProvider =
    NotifierProvider.autoDispose<DiceRitualNotifier, DiceRitualState>(
      DiceRitualNotifier.new,
    );
