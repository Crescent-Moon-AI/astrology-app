import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import '../../domain/models/chart_data.dart';
import '../../domain/models/chart_result.dart';
import 'planet_table.dart';
import 'cross_aspect_table.dart';

/// Compact chart result card for embedding in chat tool results.
class ChartResultCard extends StatelessWidget {
  final String payloadJson;

  const ChartResultCard({super.key, required this.payloadJson});

  @override
  Widget build(BuildContext context) {
    try {
      final json = jsonDecode(payloadJson) as Map<String, dynamic>;
      final chartType = json['chart_type'] as String?;

      return switch (chartType) {
        'synastry' => _SynastryCard(json: json),
        'secondary_progressions' || 'solar_arc' =>
          _ProgressionCard(json: json),
        'solar_return' || 'lunar_return' => _ReturnCard(json: json),
        'transit' => _TransitCard(json: json),
        _ => _NatalCard(json: json),
      };
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

class _NatalCard extends StatelessWidget {
  final Map<String, dynamic> json;
  const _NatalCard({required this.json});

  @override
  Widget build(BuildContext context) {
    final chart = ChartData.fromJson(json);
    return _CardWrapper(
      title: chart.info.name,
      children: [PlanetTable(planets: chart.planets)],
    );
  }
}

class _TransitCard extends StatelessWidget {
  final Map<String, dynamic> json;
  const _TransitCard({required this.json});

  @override
  Widget build(BuildContext context) {
    final result = TransitChartResult.fromJson(json);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return _CardWrapper(
      title: isZh ? '行运盘' : 'Transit Chart',
      children: [
        CrossAspectTable(
          aspects: result.crossAspects,
          label1: isZh ? '本命' : 'Natal',
          label2: isZh ? '行运' : 'Transit',
        ),
      ],
    );
  }
}

class _ProgressionCard extends StatelessWidget {
  final Map<String, dynamic> json;
  const _ProgressionCard({required this.json});

  @override
  Widget build(BuildContext context) {
    final result = ProgressionChartResult.fromJson(json);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return _CardWrapper(
      title: isZh ? '推运盘' : 'Progressions',
      children: [
        PlanetTable(planets: result.progressedPlanets, showHouse: false),
      ],
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final Map<String, dynamic> json;
  const _ReturnCard({required this.json});

  @override
  Widget build(BuildContext context) {
    final result = ReturnChartResult.fromJson(json);
    return _CardWrapper(
      title: result.returnChart.info.name,
      children: [PlanetTable(planets: result.returnChart.planets)],
    );
  }
}

class _SynastryCard extends StatelessWidget {
  final Map<String, dynamic> json;
  const _SynastryCard({required this.json});

  @override
  Widget build(BuildContext context) {
    final result = SynastryChartResult.fromJson(json);
    return _CardWrapper(
      title: '${result.person1.name} & ${result.person2.name}',
      children: [
        CrossAspectTable(
          aspects: result.crossAspects,
          label1: result.person1.name,
          label2: result.person2.name,
        ),
      ],
    );
  }
}

class _CardWrapper extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CardWrapper({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
