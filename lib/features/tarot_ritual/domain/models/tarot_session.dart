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
    // card_count and position_labels may be nested under "spread"
    final spread = json['spread'] as Map<String, dynamic>?;
    final cardCount =
        json['card_count'] as int? ?? spread?['card_count'] as int? ?? 0;

    // Extract position labels from spread.positions
    List<String> positionLabels;
    if (json['position_labels'] != null) {
      positionLabels = (json['position_labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    } else if (spread != null && spread['positions'] != null) {
      positionLabels = (spread['positions'] as List<dynamic>).map((e) {
        final pos = e as Map<String, dynamic>;
        return (pos['label_zh'] as String?) ?? (pos['label'] as String?) ?? '';
      }).toList();
    } else {
      positionLabels = [];
    }

    return TarotSession(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      spreadType: json['spread_type'] as String? ?? 'universal_three',
      cardCount: cardCount,
      question: json['question'] as String? ?? '',
      ritualState: RitualState.fromValue(json['ritual_state'] as String? ?? ''),
      selectedPositions:
          (json['selected_positions'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      selectedCards: (json['selected_cards'] as List<dynamic>?)
          ?.map((e) => ResolvedCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      positionLabels: positionLabels,
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String).toLocal()
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
