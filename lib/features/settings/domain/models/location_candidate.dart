// Models for location geocoding / resolve endpoint.
// Matches backend GET /api/locations/resolve response.

class GeocodeResponse {
  final String query;
  final List<LocationCandidate> candidates;
  final String? provider;

  const GeocodeResponse({
    required this.query,
    required this.candidates,
    this.provider,
  });

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) {
    final list = json['candidates'] as List<dynamic>? ?? [];
    return GeocodeResponse(
      query: json['query'] as String? ?? '',
      candidates: list
          .map((e) => LocationCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      provider: json['provider'] as String?,
    );
  }
}

class LocationCandidate {
  final String name;
  final String? formattedAddress;
  final double latitude;
  final double longitude;
  final String? timezone;
  final String? countryCode;
  final String? adminArea;
  final double? confidence;
  final String? id;

  const LocationCandidate({
    required this.name,
    this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.timezone,
    this.countryCode,
    this.adminArea,
    this.confidence,
    this.id,
  });

  factory LocationCandidate.fromJson(Map<String, dynamic> json) {
    return LocationCandidate(
      name: json['name'] as String? ?? '',
      formattedAddress: json['formatted_address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      timezone: json['timezone'] as String?,
      countryCode: json['country_code'] as String?,
      adminArea: json['admin_area'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }
}
