import 'lenormand_card.dart';
import 'lenormand_state.dart';

class LenormandSession {
  final String id;
  final String conversationId;
  final String spreadType;
  final int cardCount;
  final String question;
  final LenormandRitualState ritualState;
  final List<int> selectedPositions;
  final List<ResolvedLenormandCard>? selectedCards;
  final List<String> positionLabels;
  final DateTime startedAt;
  final DateTime? completedAt;

  const LenormandSession({
    required this.id,
    required this.conversationId,
    required this.spreadType,
    required this.cardCount,
    required this.question,
    required this.ritualState,
    required this.selectedPositions,
    this.selectedCards,
    required this.positionLabels,
    required this.startedAt,
    this.completedAt,
  });

  factory LenormandSession.fromJson(Map<String, dynamic> json) {
    return LenormandSession(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String? ?? '',
      spreadType: json['spread_type'] as String? ?? 'three_card',
      cardCount: json['card_count'] as int? ?? 3,
      question: json['question'] as String? ?? '',
      ritualState: LenormandRitualState.fromValue(
        json['ritual_state'] as String? ?? '',
      ),
      selectedPositions:
          (json['selected_positions'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      selectedCards: (json['selected_cards'] as List<dynamic>?)
          ?.map(
            (e) => ResolvedLenormandCard.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      positionLabels:
          (json['position_labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      startedAt: DateTime.parse(
        json['started_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  LenormandSession copyWith({
    String? id,
    String? conversationId,
    String? spreadType,
    int? cardCount,
    String? question,
    LenormandRitualState? ritualState,
    List<int>? selectedPositions,
    List<ResolvedLenormandCard>? selectedCards,
    List<String>? positionLabels,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return LenormandSession(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      spreadType: spreadType ?? this.spreadType,
      cardCount: cardCount ?? this.cardCount,
      question: question ?? this.question,
      ritualState: ritualState ?? this.ritualState,
      selectedPositions: selectedPositions ?? this.selectedPositions,
      selectedCards: selectedCards ?? this.selectedCards,
      positionLabels: positionLabels ?? this.positionLabels,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
