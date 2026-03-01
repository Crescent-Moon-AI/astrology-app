import 'dart:convert';

class AstroCalendarEvent {
  final String id;
  final String eventType;
  final String planet;
  final String sign;
  final DateTime exactDatetime;
  final String descriptionKey;
  final Map<String, dynamic>? metadata;

  const AstroCalendarEvent({
    required this.id,
    required this.eventType,
    required this.planet,
    required this.sign,
    required this.exactDatetime,
    required this.descriptionKey,
    this.metadata,
  });

  factory AstroCalendarEvent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? meta;
    final rawMeta = json['metadata'];
    if (rawMeta is Map<String, dynamic>) {
      meta = rawMeta;
    } else if (rawMeta is String && rawMeta.isNotEmpty) {
      try {
        meta = jsonDecode(rawMeta) as Map<String, dynamic>;
      } catch (_) {
        meta = null;
      }
    }

    return AstroCalendarEvent(
      id: json['id'] as String,
      eventType: json['event_type'] as String,
      planet: json['planet'] as String,
      sign: json['sign'] as String,
      exactDatetime: DateTime.parse(json['exact_datetime'] as String),
      descriptionKey: json['description_key'] as String? ?? '',
      metadata: meta,
    );
  }
}
