class HouseOverlayEntry {
  final String planetName;
  final String planetNameCn;
  final double planetLongitude;
  final int houseNumber;
  final String houseSign;
  final String houseSignCn;

  const HouseOverlayEntry({
    required this.planetName,
    required this.planetNameCn,
    required this.planetLongitude,
    required this.houseNumber,
    required this.houseSign,
    required this.houseSignCn,
  });

  factory HouseOverlayEntry.fromJson(Map<String, dynamic> json) {
    return HouseOverlayEntry(
      planetName: json['planet_name'] as String,
      planetNameCn: json['planet_name_cn'] as String,
      planetLongitude: (json['planet_longitude'] as num).toDouble(),
      houseNumber: json['house_number'] as int,
      houseSign: json['house_sign'] as String,
      houseSignCn: json['house_sign_cn'] as String,
    );
  }
}

class HouseOverlays {
  final List<HouseOverlayEntry> person1InPerson2Houses;
  final List<HouseOverlayEntry> person2InPerson1Houses;

  const HouseOverlays({
    required this.person1InPerson2Houses,
    required this.person2InPerson1Houses,
  });

  factory HouseOverlays.fromJson({
    required List<dynamic> person1In,
    required List<dynamic> person2In,
  }) {
    return HouseOverlays(
      person1InPerson2Houses: person1In
          .map((e) => HouseOverlayEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      person2InPerson1Houses: person2In
          .map((e) => HouseOverlayEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
