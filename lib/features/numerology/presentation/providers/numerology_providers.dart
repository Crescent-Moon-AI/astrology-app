import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/numerology_result.dart';
import '../../domain/models/numerology_state.dart';

class NumerologyRitualState {
  final DateTime? birthDate;
  final NumerologyResult? result;
  final NumerologyState step;
  final bool isLoading;
  final String? error;

  const NumerologyRitualState({
    this.birthDate,
    this.result,
    this.step = NumerologyState.input,
    this.isLoading = false,
    this.error,
  });

  NumerologyRitualState copyWith({
    DateTime? birthDate,
    NumerologyResult? result,
    NumerologyState? step,
    bool? isLoading,
    String? error,
  }) {
    return NumerologyRitualState(
      birthDate: birthDate ?? this.birthDate,
      result: result ?? this.result,
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NumerologyNotifier extends Notifier<NumerologyRitualState> {
  @override
  NumerologyRitualState build() {
    return const NumerologyRitualState();
  }

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  Future<void> calculate() async {
    if (state.birthDate == null) return;

    state = state.copyWith(
      step: NumerologyState.calculating,
      isLoading: true,
      error: null,
    );

    // Simulate calculation delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final date = state.birthDate!;
    final digits =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

    final steps = <int>[];
    var sum = digits.split('').fold<int>(0, (acc, d) => acc + int.parse(d));
    steps.add(sum);

    // Master numbers
    const masterNumbers = {11, 22, 33};

    while (sum > 9 && !masterNumbers.contains(sum)) {
      sum = sum
          .toString()
          .split('')
          .fold<int>(0, (acc, d) => acc + int.parse(d));
      steps.add(sum);
    }

    final isMaster = masterNumbers.contains(sum);
    final meanings = _getMeaning(sum);

    final result = NumerologyResult(
      lifePathNumber: sum,
      calculationSteps: steps,
      meaning: meanings['en']!,
      meaningZh: meanings['zh']!,
      isMasterNumber: isMaster,
    );

    state = state.copyWith(
      result: result,
      step: NumerologyState.revealed,
      isLoading: false,
    );
  }

  void startReading() {
    state = state.copyWith(step: NumerologyState.reading);
  }

  void reset() {
    state = const NumerologyRitualState();
  }

  Map<String, String> _getMeaning(int number) {
    return switch (number) {
      1 => {
        'en': 'The Leader — Independent, pioneering, ambitious',
        'zh': '领导者 — 独立、开拓、雄心勃勃',
      },
      2 => {
        'en': 'The Diplomat — Cooperative, sensitive, balanced',
        'zh': '外交家 — 合作、敏感、平衡',
      },
      3 => {
        'en': 'The Communicator — Creative, expressive, joyful',
        'zh': '传播者 — 创造力、表达力、欢乐',
      },
      4 => {
        'en': 'The Builder — Practical, disciplined, trustworthy',
        'zh': '建造者 — 务实、自律、可靠',
      },
      5 => {
        'en': 'The Adventurer — Freedom-loving, versatile, curious',
        'zh': '冒险家 — 热爱自由、多才多艺、好奇',
      },
      6 => {
        'en': 'The Nurturer — Caring, responsible, harmonious',
        'zh': '养育者 — 关怀、负责、和谐',
      },
      7 => {
        'en': 'The Seeker — Analytical, spiritual, introspective',
        'zh': '探索者 — 善于分析、灵性、内省',
      },
      8 => {
        'en': 'The Powerhouse — Ambitious, authoritative, material mastery',
        'zh': '实权者 — 雄心、权威、物质掌控',
      },
      9 => {
        'en': 'The Humanitarian — Compassionate, wise, selfless',
        'zh': '人道主义者 — 慈悲、智慧、无私',
      },
      11 => {
        'en': 'The Intuitive — Visionary, inspirational, spiritually gifted',
        'zh': '直觉者 — 有远见、鼓舞人心、灵性天赋',
      },
      22 => {
        'en': 'The Master Builder — Powerful manifester, global vision',
        'zh': '大建造者 — 强大的显化力、全球视野',
      },
      33 => {
        'en': 'The Master Teacher — Unconditional love, spiritual upliftment',
        'zh': '大导师 — 无条件的爱、灵性提升',
      },
      _ => {'en': 'A unique vibration awaits discovery', 'zh': '一个独特的振动等待发现'},
    };
  }
}

final numerologyProvider =
    NotifierProvider.autoDispose<NumerologyNotifier, NumerologyRitualState>(
      NumerologyNotifier.new,
    );
