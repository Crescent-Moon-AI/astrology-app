import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/chart/domain/models/aspect_data.dart';
import 'package:astrology_app/features/chart/presentation/widgets/aspect_table.dart';
import 'package:astrology_app/features/chart/presentation/widgets/aspect_nature_dot.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';

final _testAspects = [
  const AspectData(
    planet1: 'Sun',
    planet1Cn: '太阳',
    planet1Symbol: '☉',
    planet2: 'Moon',
    planet2Cn: '月亮',
    planet2Symbol: '☽',
    aspectName: 'Trine',
    aspectNameCn: '三分',
    aspectSymbol: '△',
    exactAngle: 120.0,
    actualAngle: 118.5,
    orb: 1.5,
    nature: AspectNature.harmonious,
    applying: true,
  ),
  const AspectData(
    planet1: 'Mars',
    planet1Cn: '火星',
    planet1Symbol: '♂',
    planet2: 'Saturn',
    planet2Cn: '土星',
    planet2Symbol: '♄',
    aspectName: 'Square',
    aspectNameCn: '四分',
    aspectSymbol: '□',
    exactAngle: 90.0,
    actualAngle: 91.2,
    orb: 1.2,
    nature: AspectNature.tense,
    applying: false,
  ),
  const AspectData(
    planet1: 'Mercury',
    planet1Cn: '水星',
    planet1Symbol: '☿',
    planet2: 'Jupiter',
    planet2Cn: '木星',
    planet2Symbol: '♃',
    aspectName: 'Conjunction',
    aspectNameCn: '合',
    aspectSymbol: '☌',
    exactAngle: 0.0,
    actualAngle: 2.3,
    orb: 2.3,
    nature: AspectNature.neutral,
    applying: false,
  ),
];

Widget _buildTestWidget({Locale locale = const Locale('zh')}) {
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
        child: AspectTable(aspects: _testAspects),
      ),
    ),
  );
}

void main() {
  group('AspectTable', () {
    testWidgets('renders aspect symbols', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      expect(find.text('△'), findsOneWidget);
      expect(find.text('□'), findsOneWidget);
      expect(find.text('☌'), findsOneWidget);
    });

    testWidgets('renders planet names in Chinese locale', (tester) async {
      await tester.pumpWidget(_buildTestWidget(locale: const Locale('zh')));

      expect(find.textContaining('太阳'), findsOneWidget);
      expect(find.textContaining('月亮'), findsOneWidget);
      expect(find.textContaining('火星'), findsOneWidget);
    });

    testWidgets('renders planet names in English locale', (tester) async {
      await tester.pumpWidget(_buildTestWidget(locale: const Locale('en')));

      expect(find.textContaining('Sun'), findsOneWidget);
      expect(find.textContaining('Moon'), findsOneWidget);
      expect(find.textContaining('Mars'), findsOneWidget);
    });

    testWidgets('renders AspectNatureDots with correct colors', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      final dots = tester.widgetList<AspectNatureDot>(find.byType(AspectNatureDot)).toList();
      expect(dots.length, 3);
      expect(dots[0].nature, AspectNature.harmonious);
      expect(dots[1].nature, AspectNature.tense);
      expect(dots[2].nature, AspectNature.neutral);
    });

    testWidgets('shows applying indicator only for applying aspects', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      // Only the first aspect (Sun trine Moon) is applying
      final arrows = find.byIcon(Icons.arrow_forward);
      expect(arrows, findsOneWidget);
    });

    testWidgets('shows formatted orb values', (tester) async {
      await tester.pumpWidget(_buildTestWidget());

      // Orb 1.5 → "1°30'"
      expect(find.text("1\u00B030'"), findsOneWidget);
      // Orb 1.2 → "1°12'"
      expect(find.text("1\u00B012'"), findsOneWidget);
      // Orb 2.3 → "2°18'"
      expect(find.text("2\u00B018'"), findsOneWidget);
    });
  });

  group('AspectNatureDot colors', () {
    testWidgets('harmonious → success color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AspectNatureDot(nature: AspectNature.harmonious)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, CosmicColors.success);
    });

    testWidgets('tense → error color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AspectNatureDot(nature: AspectNature.tense)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, CosmicColors.error);
    });

    testWidgets('neutral → primaryLight color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AspectNatureDot(nature: AspectNature.neutral)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, CosmicColors.primaryLight);
    });
  });
}
