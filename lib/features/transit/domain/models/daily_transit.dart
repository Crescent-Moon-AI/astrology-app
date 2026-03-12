class DailyTransitEvent {
  final String eventType;
  final String time;
  final String title;
  final String transitPlanet;
  final String transitPlanetCn;
  final String? natalPlanet;
  final String? natalPlanetCn;
  final String? aspectCn;
  final int? houseNumber;
  final String? signCn;
  final int? activatedHouse;

  DailyTransitEvent({
    required this.eventType,
    required this.time,
    required this.title,
    required this.transitPlanet,
    required this.transitPlanetCn,
    this.natalPlanet,
    this.natalPlanetCn,
    this.aspectCn,
    this.houseNumber,
    this.signCn,
    this.activatedHouse,
  });

  factory DailyTransitEvent.fromJson(Map<String, dynamic> json) {
    return DailyTransitEvent(
      eventType: json['event_type'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      transitPlanet: json['transit_planet'] as String,
      transitPlanetCn: json['transit_planet_cn'] as String,
      natalPlanet: json['natal_planet'] as String?,
      natalPlanetCn: json['natal_planet_cn'] as String?,
      aspectCn: json['aspect_cn'] as String?,
      houseNumber: json['house_number'] as int?,
      signCn: json['sign_cn'] as String?,
      activatedHouse: json['activated_house'] as int?,
    );
  }
}

class DailyTransitScan {
  final String scanDate;
  final List<DailyTransitEvent> events;

  DailyTransitScan({required this.scanDate, required this.events});

  factory DailyTransitScan.fromJson(Map<String, dynamic> json) {
    final eventsList = (json['events'] as List<dynamic>?) ?? [];
    return DailyTransitScan(
      scanDate: json['scan_date'] as String,
      events: eventsList
          .map((e) => DailyTransitEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
