import '../../domain/models/meihua_state.dart';

class MeihuaHexagram {
  final int number;
  final String name;
  final String nameZh;
  final String symbol;
  final int upperTrigramNumber;
  final int lowerTrigramNumber;

  const MeihuaHexagram({
    required this.number,
    required this.name,
    required this.nameZh,
    required this.symbol,
    required this.upperTrigramNumber,
    required this.lowerTrigramNumber,
  });

  factory MeihuaHexagram.fromJson(Map<String, dynamic> json) {
    return MeihuaHexagram(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameZh: json['name_zh'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      upperTrigramNumber: json['upper_trigram_number'] as int? ?? 1,
      lowerTrigramNumber: json['lower_trigram_number'] as int? ?? 1,
    );
  }
}

class MeihuaResult {
  final MeihuaHexagram primaryHexagram;
  final MeihuaHexagram transformedHexagram;
  final MeihuaHexagram? mutualHexagram;
  final int movingLine;
  final String method; // 'time' or 'number'
  final String meaning;
  final String meaningZh;

  const MeihuaResult({
    required this.primaryHexagram,
    required this.transformedHexagram,
    this.mutualHexagram,
    required this.movingLine,
    required this.method,
    required this.meaning,
    required this.meaningZh,
  });

  factory MeihuaResult.fromJson(Map<String, dynamic> json) {
    return MeihuaResult(
      primaryHexagram: MeihuaHexagram.fromJson(
        json['primary_hexagram'] as Map<String, dynamic>,
      ),
      transformedHexagram: MeihuaHexagram.fromJson(
        json['transformed_hexagram'] as Map<String, dynamic>,
      ),
      mutualHexagram: json['mutual_hexagram'] != null
          ? MeihuaHexagram.fromJson(
              json['mutual_hexagram'] as Map<String, dynamic>,
            )
          : null,
      movingLine: json['moving_line'] as int? ?? 1,
      method: json['method'] as String? ?? 'time',
      meaning: json['meaning'] as String? ?? '',
      meaningZh: json['meaning_zh'] as String? ?? '',
    );
  }
}

/// Wrapper state for the Meihua ritual flow.
class MeihuaRitualData {
  final MeihuaState step;
  final String method; // 'time' or 'number'
  final int? numberA;
  final int? numberB;
  final DateTime? selectedTime;
  final String question;
  final MeihuaResult? result;
  final bool isLoading;
  final String? error;

  const MeihuaRitualData({
    this.step = MeihuaState.selectMethod,
    this.method = '',
    this.numberA,
    this.numberB,
    this.selectedTime,
    this.question = '',
    this.result,
    this.isLoading = false,
    this.error,
  });

  MeihuaRitualData copyWith({
    MeihuaState? step,
    String? method,
    int? numberA,
    int? numberB,
    DateTime? selectedTime,
    String? question,
    MeihuaResult? result,
    bool? isLoading,
    String? error,
  }) {
    return MeihuaRitualData(
      step: step ?? this.step,
      method: method ?? this.method,
      numberA: numberA ?? this.numberA,
      numberB: numberB ?? this.numberB,
      selectedTime: selectedTime ?? this.selectedTime,
      question: question ?? this.question,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
