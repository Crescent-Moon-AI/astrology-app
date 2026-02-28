import 'ritual_state.dart';
import 'tarot_card.dart';

class TarotSession {
  final String id;
  final String conversationId;
  final String spreadType;
  final int cardCount;
  final String question;
  final RitualState ritualState;
  final List<int> selectedPositions;
  final List<ResolvedCard>? selectedCards;
  final List<String> positionLabels;
  final DateTime startedAt;
  final DateTime? completedAt;

  const TarotSession({
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

  factory TarotSession.fromJson(Map<String, dynamic> json) {
    return TarotSession(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      spreadType: json['spread_type'] as String,
      cardCount: json['card_count'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      ritualState:
          RitualState.fromValue(json['ritual_state'] as String? ?? ''),
      selectedPositions: (json['selected_positions'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      selectedCards: (json['selected_cards'] as List<dynamic>?)
          ?.map((e) => ResolvedCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      positionLabels: (json['position_labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  TarotSession copyWith({
    String? id,
    String? conversationId,
    String? spreadType,
    int? cardCount,
    String? question,
    RitualState? ritualState,
    List<int>? selectedPositions,
    List<ResolvedCard>? selectedCards,
    List<String>? positionLabels,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return TarotSession(
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
