class BirthData {
  final String name;
  final String birthDate;
  final String birthTime;
  final double latitude;
  final double longitude;
  final double timezone;
  final String location;
  final String houseSystem;

  const BirthData({
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.location = '',
    this.houseSystem = 'Placidus',
  });
}
