import 'transit_event.dart';

class UserTransitAlert {
  final String id;
  final TransitEvent transitEvent;
  final String natalPlanet;
  final double natalDegree;
  final String natalSign;
  final int? natalHouse;
  final double transitDegree;
  final String transitSign;
  final double orb;
  final bool applying;
  final String? descriptionKey;
  final DateTime createdAt;

  const UserTransitAlert({
    required this.id,
    required this.transitEvent,
    required this.natalPlanet,
    required this.natalDegree,
    required this.natalSign,
    this.natalHouse,
    required this.transitDegree,
    required this.transitSign,
    required this.orb,
    required this.applying,
    this.descriptionKey,
    required this.createdAt,
  });

  factory UserTransitAlert.fromJson(Map<String, dynamic> json) {
    return UserTransitAlert(
      id: json['id'] as String,
      transitEvent:
          TransitEvent.fromJson(json['transit_event'] as Map<String, dynamic>),
      natalPlanet: json['natal_planet'] as String,
      natalDegree: (json['natal_degree'] as num).toDouble(),
      natalSign: json['natal_sign'] as String,
      natalHouse: json['natal_house'] as int?,
      transitDegree: (json['transit_degree'] as num).toDouble(),
      transitSign: json['transit_sign'] as String,
      orb: (json['orb'] as num).toDouble(),
      applying: json['applying'] as bool? ?? true,
      descriptionKey: json['description_key'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
