import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/meihua_result.dart';
import '../../domain/models/meihua_state.dart';

class MeihuaNotifier extends Notifier<MeihuaRitualData> {
  @override
  MeihuaRitualData build() {
    return const MeihuaRitualData();
  }

  void selectMethod(String method) {
    state = state.copyWith(method: method, step: MeihuaState.input);
  }

  void setQuestion(String question) {
    state = state.copyWith(question: question);
  }

  void setNumbers(int a, int b) {
    state = state.copyWith(numberA: a, numberB: b);
  }

  void setTime(DateTime time) {
    state = state.copyWith(selectedTime: time);
  }

  Future<void> calculate() async {
    state = state.copyWith(
      step: MeihuaState.calculating,
      isLoading: true,
      error: null,
    );

    // Simulate calculation delay
    await Future.delayed(const Duration(milliseconds: 1200));

    int upperNum;
    int lowerNum;
    int movingLine;

    if (state.method == 'time') {
      final time = state.selectedTime ?? DateTime.now();
      upperNum = (time.hour + time.month) % 8;
      lowerNum = (time.minute + time.day) % 8;
      movingLine = (time.hour + time.minute + time.second) % 6 + 1;
    } else {
      upperNum = (state.numberA ?? 1) % 8;
      lowerNum = (state.numberB ?? 1) % 8;
      movingLine = ((state.numberA ?? 1) + (state.numberB ?? 1)) % 6 + 1;
    }

    // Ensure 1-8 range
    if (upperNum == 0) upperNum = 8;
    if (lowerNum == 0) lowerNum = 8;

    final primary = MeihuaHexagram(
      number: upperNum * 8 + lowerNum,
      name: 'Primary Hexagram',
      nameZh: '本卦',
      symbol: '\u4DC0',
      upperTrigramNumber: upperNum,
      lowerTrigramNumber: lowerNum,
    );

    // Transform: flip the moving line's trigram
    final transformedUpper = movingLine > 3 ? (9 - upperNum) : upperNum;
    final transformedLower = movingLine <= 3 ? (9 - lowerNum) : lowerNum;

    final transformed = MeihuaHexagram(
      number: transformedUpper * 8 + transformedLower,
      name: 'Transformed Hexagram',
      nameZh: '变卦',
      symbol: '\u4DC1',
      upperTrigramNumber: transformedUpper,
      lowerTrigramNumber: transformedLower,
    );

    final result = MeihuaResult(
      primaryHexagram: primary,
      transformedHexagram: transformed,
      movingLine: movingLine,
      method: state.method,
      meaning: 'The hexagram reveals the pattern of change in your situation.',
      meaningZh: '卦象揭示了你所处形势中的变化规律。',
    );

    state = state.copyWith(
      result: result,
      step: MeihuaState.revealed,
      isLoading: false,
    );
  }

  void startReading() {
    state = state.copyWith(step: MeihuaState.reading);
  }

  void reset() {
    state = const MeihuaRitualData();
  }
}

final meihuaProvider =
    NotifierProvider.autoDispose<MeihuaNotifier, MeihuaRitualData>(
      MeihuaNotifier.new,
    );
