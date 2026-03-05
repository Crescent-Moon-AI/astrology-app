import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:astrology_app/core/astro/astro_engine.dart';
import 'package:astrology_app/features/chart/domain/models/birth_data.dart';
import 'package:astrology_app/features/chart/domain/models/chart_request.dart';
import 'package:astrology_app/features/chart/domain/models/chart_result.dart';
import 'package:astrology_app/features/chart/domain/services/chart_calculation_service.dart';

class MockAstroEngine extends Mock implements AstroEngine {}

Map<String, dynamic> _loadGolden(String name) {
  final file = File('test/fixtures/golden_data/$name.json');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

final _testBirth = BirthData(
  name: 'Test',
  birthDate: '1990-06-25',
  birthTime: '10:30',
  latitude: 31.23,
  longitude: 121.47,
  timezone: 8.0,
  location: 'Shanghai',
);

void main() {
  late MockAstroEngine engine;
  late ChartCalculationService service;

  setUp(() {
    engine = MockAstroEngine();
    service = ChartCalculationService(engine);
    when(() => engine.isAvailable).thenReturn(true);
  });

  group('ChartCalculationService.calculate dispatches correctly', () {
    test('NatalChartRequest → calculateNatalChart', () async {
      final goldenJson = _loadGolden('natal_shanghai_1990');
      when(() => engine.calculateNatalChart(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            name: any(named: 'name'),
            location: any(named: 'location'),
          )).thenAnswer((_) async => goldenJson);

      final result =
          await service.calculate(NatalChartRequest(birth: _testBirth));

      expect(result, isA<NatalChartResult>());
      final natal = result as NatalChartResult;
      expect(natal.chart.planets.length, 12);
      verify(() => engine.calculateNatalChart(
            birthDate: '1990-06-25',
            birthTime: '10:30',
            latitude: 31.23,
            longitude: 121.47,
            timezone: 8.0,
            houseSystem: 'Placidus',
            name: 'Test',
            location: 'Shanghai',
          )).called(1);
    });

    test('TransitChartRequest → calculateMulti', () async {
      // Build a minimal transit response
      final natalJson = _loadGolden('natal_shanghai_1990');
      final transitResponse = {
        'transit': {
          'natal_chart': natalJson,
          'transit': natalJson,
          'cross_aspects': <dynamic>[],
          'transit_datetime': '2026-03-05 12:00',
        },
      };
      when(() => engine.calculateMulti(input: any(named: 'input')))
          .thenAnswer((_) async => transitResponse);

      final result = await service.calculate(TransitChartRequest(
        birth: _testBirth,
        transitDate: DateTime(2026, 3, 5, 12, 0),
      ));

      expect(result, isA<TransitChartResult>());
      verify(() => engine.calculateMulti(input: any(named: 'input'))).called(1);
    });

    test('SecondaryProgressionRequest → calculateProgressions', () async {
      final goldenJson = _loadGolden('progressions_secondary');
      when(() => engine.calculateProgressions(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            progressionDate: any(named: 'progressionDate'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => goldenJson);

      final result = await service.calculate(SecondaryProgressionRequest(
        birth: _testBirth,
        progressionDate: DateTime(2026, 3, 5),
      ));

      expect(result, isA<ProgressionChartResult>());
      verify(() => engine.calculateProgressions(
            birthDate: '1990-06-25',
            birthTime: '10:30',
            latitude: 31.23,
            longitude: 121.47,
            timezone: 8.0,
            houseSystem: 'Placidus',
            progressionDate: '2026-03-05',
            method: 'secondary',
          )).called(1);
    });

    test('SolarArcRequest → calculateProgressions with solar_arc method',
        () async {
      final goldenJson = _loadGolden('progressions_secondary');
      when(() => engine.calculateProgressions(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            progressionDate: any(named: 'progressionDate'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => goldenJson);

      final result = await service.calculate(SolarArcRequest(
        birth: _testBirth,
        progressionDate: DateTime(2026, 3, 5),
      ));

      expect(result, isA<ProgressionChartResult>());
      verify(() => engine.calculateProgressions(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            progressionDate: '2026-03-05',
            method: 'solar_arc',
          )).called(1);
    });

    test('SolarReturnRequest → findSolarReturn', () async {
      final goldenJson = _loadGolden('solar_return_2026');
      when(() => engine.findSolarReturn(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            year: any(named: 'year'),
          )).thenAnswer((_) async => goldenJson);

      final result = await service.calculate(SolarReturnRequest(
        birth: _testBirth,
        year: 2026,
      ));

      expect(result, isA<ReturnChartResult>());
      verify(() => engine.findSolarReturn(
            birthDate: '1990-06-25',
            birthTime: '10:30',
            latitude: 31.23,
            longitude: 121.47,
            timezone: 8.0,
            houseSystem: 'Placidus',
            year: 2026,
          )).called(1);
    });

    test('LunarReturnRequest → findLunarReturn', () async {
      final goldenJson = _loadGolden('lunar_return_2026');
      when(() => engine.findLunarReturn(
            birthDate: any(named: 'birthDate'),
            birthTime: any(named: 'birthTime'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            timezone: any(named: 'timezone'),
            houseSystem: any(named: 'houseSystem'),
            targetDate: any(named: 'targetDate'),
          )).thenAnswer((_) async => goldenJson);

      final result = await service.calculate(LunarReturnRequest(
        birth: _testBirth,
        targetDate: DateTime(2026, 3, 5),
      ));

      expect(result, isA<ReturnChartResult>());
      verify(() => engine.findLunarReturn(
            birthDate: '1990-06-25',
            birthTime: '10:30',
            latitude: 31.23,
            longitude: 121.47,
            timezone: 8.0,
            houseSystem: 'Placidus',
            targetDate: '2026-03-05',
          )).called(1);
    });

    test('SynastryRequest → calculateSynastry', () async {
      final goldenJson = _loadGolden('synastry_alice_bob');
      when(() => engine.calculateSynastry(input: any(named: 'input')))
          .thenAnswer((_) async => goldenJson);

      final person2 = BirthData(
        name: 'Bob',
        birthDate: '1988-12-01',
        birthTime: '14:00',
        latitude: 39.9,
        longitude: 116.4,
        timezone: 8.0,
        location: 'Beijing',
      );
      final result = await service.calculate(SynastryRequest(
        person1: _testBirth,
        person2: person2,
      ));

      expect(result, isA<SynastryChartResult>());
      verify(() => engine.calculateSynastry(input: any(named: 'input')))
          .called(1);
    });
  });

  test('engine returns null → service returns null', () async {
    when(() => engine.calculateNatalChart(
          birthDate: any(named: 'birthDate'),
          birthTime: any(named: 'birthTime'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          timezone: any(named: 'timezone'),
          houseSystem: any(named: 'houseSystem'),
          name: any(named: 'name'),
          location: any(named: 'location'),
        )).thenAnswer((_) async => null);

    final result =
        await service.calculate(NatalChartRequest(birth: _testBirth));
    expect(result, isNull);
  });
}
