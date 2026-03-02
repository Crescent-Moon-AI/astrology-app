import 'coin_toss.dart';
import 'hexagram.dart';
import 'iching_state.dart';

class IChingSession {
  final String id;
  final String conversationId;
  final String question;
  final IChingRitualState ritualState;
  final List<CoinToss> tosses;
  final Hexagram? primaryHexagram;
  final Hexagram? transformedHexagram;
  final DateTime startedAt;
  final DateTime? completedAt;

  const IChingSession({
    required this.id,
    required this.conversationId,
    required this.question,
    required this.ritualState,
    required this.tosses,
    this.primaryHexagram,
    this.transformedHexagram,
    required this.startedAt,
    this.completedAt,
  });

  factory IChingSession.fromJson(Map<String, dynamic> json) {
    return IChingSession(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      ritualState: IChingRitualState.fromValue(
        json['ritual_state'] as String? ?? '',
      ),
      tosses:
          (json['tosses'] as List<dynamic>?)
              ?.map((e) => CoinToss.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      primaryHexagram: json['primary_hexagram'] != null
          ? Hexagram.fromJson(json['primary_hexagram'] as Map<String, dynamic>)
          : null,
      transformedHexagram: json['transformed_hexagram'] != null
          ? Hexagram.fromJson(
              json['transformed_hexagram'] as Map<String, dynamic>,
            )
          : null,
      startedAt: DateTime.parse(
        json['started_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  IChingSession copyWith({
    String? id,
    String? conversationId,
    String? question,
    IChingRitualState? ritualState,
    List<CoinToss>? tosses,
    Hexagram? primaryHexagram,
    Hexagram? transformedHexagram,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return IChingSession(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      question: question ?? this.question,
      ritualState: ritualState ?? this.ritualState,
      tosses: tosses ?? this.tosses,
      primaryHexagram: primaryHexagram ?? this.primaryHexagram,
      transformedHexagram: transformedHexagram ?? this.transformedHexagram,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get allTossesComplete => tosses.length >= 6;
  bool get hasMovingLines => tosses.any((t) => t.isMoving);
}
