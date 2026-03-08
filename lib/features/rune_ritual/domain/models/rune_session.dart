import 'rune_card.dart';
import 'rune_state.dart';

class RuneSession {
  final String id;
  final String conversationId;
  final String spreadType;
  final int runeCount;
  final String question;
  final RuneRitualState ritualState;
  final List<RuneDefinition>? drawnRunes;
  final List<String> positionLabels;
  final DateTime startedAt;
  final DateTime? completedAt;

  const RuneSession({
    required this.id,
    required this.conversationId,
    required this.spreadType,
    required this.runeCount,
    required this.question,
    required this.ritualState,
    this.drawnRunes,
    required this.positionLabels,
    required this.startedAt,
    this.completedAt,
  });

  factory RuneSession.fromJson(Map<String, dynamic> json) {
    return RuneSession(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String? ?? '',
      spreadType: json['spread_type'] as String? ?? 'three_rune',
      runeCount: json['rune_count'] as int? ?? 3,
      question: json['question'] as String? ?? '',
      ritualState: RuneRitualState.fromValue(
        json['ritual_state'] as String? ?? '',
      ),
      drawnRunes: (json['drawn_runes'] as List<dynamic>?)
          ?.map((e) => RuneDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      positionLabels:
          (json['position_labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      startedAt: DateTime.parse(
        json['started_at'] as String? ?? DateTime.now().toIso8601String(),
      ).toLocal(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String).toLocal()
          : null,
    );
  }

  RuneSession copyWith({
    String? id,
    String? conversationId,
    String? spreadType,
    int? runeCount,
    String? question,
    RuneRitualState? ritualState,
    List<RuneDefinition>? drawnRunes,
    List<String>? positionLabels,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return RuneSession(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      spreadType: spreadType ?? this.spreadType,
      runeCount: runeCount ?? this.runeCount,
      question: question ?? this.question,
      ritualState: ritualState ?? this.ritualState,
      drawnRunes: drawnRunes ?? this.drawnRunes,
      positionLabels: positionLabels ?? this.positionLabels,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
