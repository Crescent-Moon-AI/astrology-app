class FriendProfile {
  final String id;
  final String name;
  final String birthDate;
  final String? birthTime;
  final double latitude;
  final double longitude;
  final String timezone;
  final String birthLocationName;
  final String relationshipLabel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FriendProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    this.birthTime,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.birthLocationName,
    required this.relationshipLabel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FriendProfile.fromJson(Map<String, dynamic> json) {
    return FriendProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: json['birth_date'] as String,
      birthTime: json['birth_time'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String? ?? 'UTC',
      birthLocationName: json['birth_location_name'] as String? ?? '',
      relationshipLabel: json['relationship_label'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

enum RelationshipLabel {
  partner('partner', 'Partner', '\u4F34\u4FA3'),
  family('family', 'Family', '\u5BB6\u4EBA'),
  friend('friend', 'Friend', '\u670B\u53CB'),
  colleague('colleague', 'Colleague', '\u540C\u4E8B'),
  crush('crush', 'Crush', '\u5FC3\u4EEA\u7684\u4EBA');

  const RelationshipLabel(this.value, this.labelEN, this.labelZH);
  final String value;
  final String labelEN;
  final String labelZH;

  static RelationshipLabel? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return RelationshipLabel.values.where((e) => e.value == value).firstOrNull;
  }
}
