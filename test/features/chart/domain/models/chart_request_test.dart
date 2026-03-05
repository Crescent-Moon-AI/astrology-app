import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/chart/domain/models/chart_request.dart';
import 'package:astrology_app/features/chart/domain/models/birth_data.dart';

void main() {
  final testBirth = BirthData(
    name: 'Test',
    birthDate: '1990-06-15',
    birthTime: '14:30',
    latitude: 31.2304,
    longitude: 121.4737,
    timezone: 8.0,
  );

  group('ChartRequest sealed class', () {
    test('exhaustive switch covers all 7 types', () {
      final requests = <ChartRequest>[
        NatalChartRequest(birth: testBirth),
        TransitChartRequest(birth: testBirth, transitDate: DateTime.now()),
        SecondaryProgressionRequest(
          birth: testBirth,
          progressionDate: DateTime.now(),
        ),
        SolarArcRequest(birth: testBirth, progressionDate: DateTime.now()),
        SolarReturnRequest(birth: testBirth, year: 2026),
        LunarReturnRequest(birth: testBirth, targetDate: DateTime.now()),
        SynastryRequest(person1: testBirth, person2: testBirth),
      ];

      for (final req in requests) {
        final label = switch (req) {
          NatalChartRequest() => 'natal',
          TransitChartRequest() => 'transit',
          SecondaryProgressionRequest() => 'secondary',
          SolarArcRequest() => 'solarArc',
          SolarReturnRequest() => 'solarReturn',
          LunarReturnRequest() => 'lunarReturn',
          SynastryRequest() => 'synastry',
        };
        expect(label, isNotEmpty);
      }

      expect(requests.length, 7);
    });

    test('NatalChartRequest holds birth data', () {
      final req = NatalChartRequest(birth: testBirth);
      expect(req.birth.name, 'Test');
      expect(req.birth.latitude, 31.2304);
    });

    test('SynastryRequest holds two persons', () {
      final person2 = BirthData(
        name: 'Person2',
        birthDate: '1992-03-20',
        birthTime: '08:00',
        latitude: 39.9042,
        longitude: 116.4074,
        timezone: 8.0,
      );
      final req = SynastryRequest(person1: testBirth, person2: person2);
      expect(req.person1.name, 'Test');
      expect(req.person2.name, 'Person2');
    });
  });
}
