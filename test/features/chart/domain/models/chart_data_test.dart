import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/chart/domain/models/chart_data.dart';
import 'package:astrology_app/features/chart/domain/models/planet_data.dart';

Map<String, dynamic> _loadGolden(String name) {
  final file = File('test/fixtures/golden_data/$name.json');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

List<dynamic> _loadGoldenList(String name) {
  final file = File('test/fixtures/golden_data/$name.json');
  return jsonDecode(file.readAsStringSync()) as List<dynamic>;
}

void main() {
  group('ChartData.fromJson — golden data cross-validation', () {
    test('parses natal_shanghai_1990 correctly', () {
      final json = _loadGolden('natal_shanghai_1990');
      final chart = ChartData.fromJson(json);

      expect(chart.info.name, 'TestCase1');
      expect(chart.info.date, '1990-06-15 14:30:00');
      expect(chart.info.latitude, closeTo(31.2304, 0.001));
      expect(chart.info.longitude, closeTo(121.4737, 0.001));
      expect(chart.info.timezoneOffset, 8.0);

      // 12 planets (10 + NorthNode + SouthNode)
      expect(chart.planets.length, 12);
      final sun = chart.planets.first;
      expect(sun.name, 'Sun');
      expect(sun.nameCn, '太阳');
      expect(sun.symbol, '☉');
      expect(sun.sign, 'Gemini');
      expect(sun.signCn, '双子座');
      expect(sun.degree, 23);
      expect(sun.minute, 54);
      expect(sun.retrograde, false);
      expect(sun.house, 8);

      // Houses
      expect(chart.houses.system, 'Placidus');
      expect(chart.houses.cusps.length, 12);
      expect(chart.houses.cusps.first.number, 1);
      expect(chart.houses.angles.ascSign, 'Libra');
      expect(chart.houses.angles.ascSignCn, '天秤座');

      // Aspects
      expect(chart.aspects, isNotEmpty);
      final firstAspect = chart.aspects.first;
      expect(firstAspect.planet1, isNotEmpty);
      expect(firstAspect.aspectName, isNotEmpty);

      // Empty optional arrays
      expect(chart.asteroids, isEmpty);
      expect(chart.fixedStars, isEmpty);
      expect(chart.starConjunctions, isEmpty);
    });

    test('parses natal_newyork_1985 correctly', () {
      final json = _loadGolden('natal_newyork_1985');
      final chart = ChartData.fromJson(json);

      expect(chart.planets.length, 12);
      expect(chart.info.timezoneOffset, -5.0);
      expect(chart.houses.cusps.length, 12);
    });

    test('parses natal_reykjavik_1995 (extreme latitude)', () {
      final json = _loadGolden('natal_reykjavik_1995');
      final chart = ChartData.fromJson(json);

      expect(chart.planets.length, 12);
      expect(chart.info.latitude, closeTo(64.1466, 0.001));
      expect(chart.houses.cusps.length, 12);
    });

    test('parses natal_beijing_j2000 correctly', () {
      final json = _loadGolden('natal_beijing_j2000');
      final chart = ChartData.fromJson(json);

      expect(chart.planets.length, 12);
      expect(chart.info.latitude, closeTo(39.9042, 0.001));
    });

    test('parses natal_shanghai_koch (alternative house system)', () {
      final json = _loadGolden('natal_shanghai_koch');
      final chart = ChartData.fromJson(json);

      expect(chart.houses.system, 'Koch');
      expect(chart.houses.cusps.length, 12);
      expect(chart.planets.length, 12);
    });
  });

  group('PlanetData.fromJson — golden planet lists', () {
    test('parses natal_shanghai_1990_planets', () {
      final list = _loadGoldenList('natal_shanghai_1990_planets');
      final planets =
          list.map((e) => PlanetData.fromJson(e as Map<String, dynamic>)).toList();

      expect(planets.length, greaterThanOrEqualTo(10));
      expect(planets.first.name, 'Sun');
      expect(planets.first.longitude, isA<double>());
    });

    test('parses natal_beijing_j2000_planets', () {
      final list = _loadGoldenList('natal_beijing_j2000_planets');
      final planets =
          list.map((e) => PlanetData.fromJson(e as Map<String, dynamic>)).toList();

      expect(planets.length, greaterThanOrEqualTo(10));
    });
  });
}
