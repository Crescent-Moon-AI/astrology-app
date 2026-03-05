import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/chart/domain/models/chart_result.dart';
import 'package:astrology_app/features/chart/domain/models/aspect_data.dart';

Map<String, dynamic> _loadGolden(String name) {
  final file = File('test/fixtures/golden_data/$name.json');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

void main() {
  group('ProgressionChartResult.fromJson — golden data', () {
    test('parses progressions_secondary correctly', () {
      final json = _loadGolden('progressions_secondary');
      final result = ProgressionChartResult.fromJson(json);

      expect(result.progressionMethod, 'secondary_progressions');
      expect(result.progressionDate, isNotEmpty);
      expect(result.arcDegrees, isNull);

      // Natal chart should have full data
      expect(result.natal.planets.length, 12);
      expect(result.natal.houses.cusps.length, 12);

      // Progressed planets
      expect(result.progressedPlanets.length, 12);
      final progressedSun = result.progressedPlanets.first;
      expect(progressedSun.name, 'Sun');
      expect(progressedSun.longitude, isA<double>());
      // Progressed planets may have null houses
      expect(
        result.progressedPlanets.any((p) => p.house == null),
        isTrue,
      );

      // Cross aspects between progressed and natal
      expect(result.crossAspects, isNotEmpty);
    });
  });

  group('ReturnChartResult.fromJson — golden data', () {
    test('parses solar_return_2026 correctly', () {
      final json = _loadGolden('solar_return_2026');
      final result = ReturnChartResult.fromJson(json);

      expect(result.returnYear, 2026);
      expect(result.returnNumber, isNull);
      expect(result.returnDatetime, contains('2026'));

      // Natal chart
      expect(result.natal.planets.length, 12);

      // Return chart
      expect(result.returnChart.planets.length, 12);
      expect(result.returnChart.houses.cusps.length, 12);
    });

    test('parses lunar_return_2026 correctly', () {
      final json = _loadGolden('lunar_return_2026');
      final result = ReturnChartResult.fromJson(json);

      expect(result.returnYear, isNull);
      expect(result.returnNumber, 478);
      expect(result.returnDatetime, isNotEmpty);

      expect(result.natal.planets.length, 12);
      expect(result.returnChart.planets.length, 12);
    });
  });

  group('SynastryChartResult.fromJson — golden data', () {
    test('parses synastry_alice_bob correctly', () {
      final json = _loadGolden('synastry_alice_bob');
      final result = SynastryChartResult.fromJson(json);

      expect(result.person1.name, 'Alice');
      expect(result.person2.name, 'Bob');

      // Both charts should have full data
      expect(result.person1.chart.planets.length, 12);
      expect(result.person2.chart.planets.length, 12);

      // Cross aspects
      expect(result.crossAspects, isNotEmpty);

      // House overlays (12 planets each)
      expect(result.houseOverlays.person1InPerson2Houses.length, 12);
      expect(result.houseOverlays.person2InPerson1Houses.length, 12);

      // Verify overlay entry structure
      final firstOverlay = result.houseOverlays.person1InPerson2Houses.first;
      expect(firstOverlay.planetName, isNotEmpty);
      expect(firstOverlay.houseNumber, inInclusiveRange(1, 12));
    });
  });

  group('AspectNature parsing', () {
    test('all nature values parse correctly', () {
      expect(AspectNature.fromString('harmonious'), AspectNature.harmonious);
      expect(AspectNature.fromString('tense'), AspectNature.tense);
      expect(AspectNature.fromString('neutral'), AspectNature.neutral);
      expect(AspectNature.fromString('minor'), AspectNature.minor);
      expect(AspectNature.fromString('creative'), AspectNature.creative);
      expect(AspectNature.fromString('unknown'), AspectNature.neutral);
    });
  });
}
