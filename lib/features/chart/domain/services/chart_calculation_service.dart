import 'package:astrology_app/core/astro/astro_engine.dart';
import 'package:astrology_app/features/chart/domain/models/birth_data.dart';
import 'package:astrology_app/features/chart/domain/models/chart_request.dart';
import 'package:astrology_app/features/chart/domain/models/chart_result.dart';
import 'package:astrology_app/features/chart/domain/models/chart_data.dart';
import 'package:intl/intl.dart';

class ChartCalculationService {
  final AstroEngine _engine;

  ChartCalculationService(this._engine);

  bool get isAvailable => _engine.isAvailable;

  Future<ChartResult?> calculate(ChartRequest request) async {
    return switch (request) {
      NatalChartRequest(:final birth) => _calculateNatal(birth),
      TransitChartRequest(:final birth, :final transitDate) =>
        _calculateTransit(birth, transitDate),
      SecondaryProgressionRequest(:final birth, :final progressionDate) =>
        _calculateProgression(birth, progressionDate, 'secondary'),
      SolarArcRequest(:final birth, :final progressionDate) =>
        _calculateProgression(birth, progressionDate, 'solar_arc'),
      SolarReturnRequest(:final birth, :final year) => _calculateSolarReturn(
        birth,
        year,
      ),
      LunarReturnRequest(:final birth, :final targetDate) =>
        _calculateLunarReturn(birth, targetDate),
      SynastryRequest(:final person1, :final person2) => _calculateSynastry(
        person1,
        person2,
      ),
    };
  }

  /// Build the common birth data fields for JSON input.
  Map<String, dynamic> _birthFields(BirthData birth) => {
    'birth_date': birth.birthDate,
    'birth_time': birth.birthTime,
    'latitude': birth.latitude,
    'longitude': birth.longitude,
    'timezone': birth.timezone,
    if (birth.timezoneId != null) 'timezone_id': birth.timezoneId,
    'house_system': birth.houseSystem,
    'name': birth.name,
    'location': birth.location,
  };

  Future<NatalChartResult?> _calculateNatal(BirthData birth) async {
    final json = await _engine.calculateNatalChart(
      birthDate: birth.birthDate,
      birthTime: birth.birthTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      houseSystem: birth.houseSystem,
      name: birth.name,
      location: birth.location,
    );
    if (json == null) return null;
    return NatalChartResult(chart: ChartData.fromJson(json));
  }

  Future<TransitChartResult?> _calculateTransit(
    BirthData birth,
    DateTime transitDate,
  ) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(transitDate);
    final timeStr = DateFormat('HH:mm').format(transitDate);
    final input = {
      ..._birthFields(birth),
      'transit_options': {
        'date': dateStr,
        'time': timeStr,
        'latitude': birth.latitude,
        'longitude': birth.longitude,
      },
    };
    final json = await _engine.calculateMulti(input: input);
    if (json == null) return null;
    final transit = json['transit'] as Map<String, dynamic>?;
    if (transit == null) return null;
    return TransitChartResult.fromJson(transit);
  }

  Future<ProgressionChartResult?> _calculateProgression(
    BirthData birth,
    DateTime progressionDate,
    String method,
  ) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(progressionDate);
    final json = await _engine.calculateProgressions(
      birthDate: birth.birthDate,
      birthTime: birth.birthTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      houseSystem: birth.houseSystem,
      progressionDate: dateStr,
      method: method,
    );
    if (json == null) return null;
    return ProgressionChartResult.fromJson(json);
  }

  Future<ReturnChartResult?> _calculateSolarReturn(
    BirthData birth,
    int year,
  ) async {
    final json = await _engine.findSolarReturn(
      birthDate: birth.birthDate,
      birthTime: birth.birthTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      houseSystem: birth.houseSystem,
      year: year,
    );
    if (json == null) return null;
    return ReturnChartResult.fromJson(json);
  }

  Future<ReturnChartResult?> _calculateLunarReturn(
    BirthData birth,
    DateTime targetDate,
  ) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(targetDate);
    final json = await _engine.findLunarReturn(
      birthDate: birth.birthDate,
      birthTime: birth.birthTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      houseSystem: birth.houseSystem,
      targetDate: dateStr,
    );
    if (json == null) return null;
    return ReturnChartResult.fromJson(json);
  }

  Future<SynastryChartResult?> _calculateSynastry(
    BirthData person1,
    BirthData person2,
  ) async {
    final input = {
      'person1_name': person1.name,
      'person1_birth_date': person1.birthDate,
      'person1_birth_time': person1.birthTime,
      'person1_latitude': person1.latitude,
      'person1_longitude': person1.longitude,
      'person1_timezone': person1.timezone,
      if (person1.timezoneId != null) 'person1_timezone_id': person1.timezoneId,
      'person2_name': person2.name,
      'person2_birth_date': person2.birthDate,
      'person2_birth_time': person2.birthTime,
      'person2_latitude': person2.latitude,
      'person2_longitude': person2.longitude,
      'person2_timezone': person2.timezone,
      if (person2.timezoneId != null) 'person2_timezone_id': person2.timezoneId,
      'house_system': person1.houseSystem,
    };
    final json = await _engine.calculateSynastry(input: input);
    if (json == null) return null;
    return SynastryChartResult.fromJson(json);
  }
}
