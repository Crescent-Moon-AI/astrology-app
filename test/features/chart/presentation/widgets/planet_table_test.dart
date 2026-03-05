import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/chart/domain/models/planet_data.dart';
import 'package:astrology_app/features/chart/presentation/widgets/planet_table.dart';

final _testPlanets = [
  const PlanetData(
    name: 'Sun',
    nameCn: '太阳',
    symbol: '☉',
    longitude: 83.91,
    latitude: 0.0,
    distance: 1.015,
    speed: 0.953,
    retrograde: false,
    sign: 'Gemini',
    signCn: '双子座',
    signSymbol: '♊',
    degree: 23,
    minute: 54,
    second: 38,
    house: 10,
  ),
  const PlanetData(
    name: 'Saturn',
    nameCn: '土星',
    symbol: '♄',
    longitude: 280.0,
    latitude: 0.5,
    distance: 9.8,
    speed: -0.02,
    retrograde: true,
    sign: 'Capricorn',
    signCn: '摩羯座',
    signSymbol: '♑',
    degree: 10,
    minute: 0,
    second: 0,
    house: 4,
  ),
];

Widget _buildTestWidget({Locale locale = const Locale('zh'), bool showHouse = true}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('zh'), Locale('en')],
    home: Scaffold(
      body: SingleChildScrollView(
        child: PlanetTable(planets: _testPlanets, showHouse: showHouse),
      ),
    ),
  );
}

void main() {
  group('PlanetTable', () {
    testWidgets('renders planet names in Chinese locale', (tester) async {
      await tester.pumpWidget(_buildTestWidget(locale: const Locale('zh')));

      expect(find.text('太阳'), findsOneWidget);
      expect(find.text('土星'), findsOneWidget);
      // Header
      expect(find.text('行星'), findsOneWidget);
      expect(find.text('星座 / 度数'), findsOneWidget);
    });

    testWidgets('renders planet names in English locale', (tester) async {
      await tester.pumpWidget(_buildTestWidget(locale: const Locale('en')));

      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Saturn'), findsOneWidget);
      expect(find.text('Planet'), findsOneWidget);
      expect(find.text('Sign / Degree'), findsOneWidget);
    });

    testWidgets('shows planet symbols', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      expect(find.text('☉'), findsOneWidget);
      expect(find.text('♄'), findsOneWidget);
    });

    testWidgets('shows house numbers when showHouse=true', (tester) async {
      await tester.pumpWidget(_buildTestWidget(showHouse: true));

      expect(find.text('10'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('hides house column when showHouse=false', (tester) async {
      await tester.pumpWidget(_buildTestWidget(showHouse: false));

      // No house header
      expect(find.text('宫位'), findsNothing);
    });

    testWidgets('shows retrograde badge for retrograde planets', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      // Saturn is retrograde, should show Rx
      expect(find.text('Rx'), findsOneWidget);
    });
  });
}
