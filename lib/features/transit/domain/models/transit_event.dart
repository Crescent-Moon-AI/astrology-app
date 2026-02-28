class TransitEvent {
  final String id;
  final String eventType;
  final String planet;
  final String? targetPlanet;
  final String? aspectType;
  final String sign;
  final String exactDate;
  final String startDate;
  final String endDate;
  final String severity;
  final String descriptionKey;
  final Map<String, dynamic>? metadata;

  const TransitEvent({
    required this.id,
    required this.eventType,
    required this.planet,
    this.targetPlanet,
    this.aspectType,
    required this.sign,
    required this.exactDate,
    required this.startDate,
    required this.endDate,
    required this.severity,
    required this.descriptionKey,
    this.metadata,
  });

  factory TransitEvent.fromJson(Map<String, dynamic> json) {
    return TransitEvent(
      id: json['id'] as String,
      eventType: json['event_type'] as String,
      planet: json['planet'] as String,
      targetPlanet: json['target_planet'] as String?,
      aspectType: json['aspect_type'] as String?,
      sign: json['sign'] as String? ?? '',
      exactDate: json['exact_date'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      severity: json['severity'] as String? ?? 'low',
      descriptionKey: json['description_key'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
