import 'chart_data.dart';
import 'planet_data.dart';
import 'aspect_data.dart';
import 'house_overlay_data.dart';

sealed class ChartResult {
  const ChartResult();
}

class NatalChartResult extends ChartResult {
  final ChartData chart;
  const NatalChartResult({required this.chart});

  factory NatalChartResult.fromJson(Map<String, dynamic> json) {
    return NatalChartResult(chart: ChartData.fromJson(json));
  }
}

class TransitChartResult extends ChartResult {
  final ChartData natal;
  final ChartData transit;
  final List<AspectData> crossAspects;
  final String transitDatetime;

  const TransitChartResult({
    required this.natal,
    required this.transit,
    required this.crossAspects,
    required this.transitDatetime,
  });

  factory TransitChartResult.fromJson(Map<String, dynamic> json) {
    // Support both Rust serde ("natal") and Python golden ("natal_chart") keys
    final natalJson =
        (json['natal_chart'] ?? json['natal']) as Map<String, dynamic>;
    return TransitChartResult(
      natal: ChartData.fromJson(natalJson),
      transit: ChartData.fromJson(json['transit'] as Map<String, dynamic>),
      crossAspects: (json['cross_aspects'] as List<dynamic>)
          .map((e) => AspectData.fromJson(e as Map<String, dynamic>))
          .toList(),
      transitDatetime: json['transit_datetime'] as String,
    );
  }
}

class ProgressionChartResult extends ChartResult {
  final ChartData natal;
  final List<PlanetData> progressedPlanets;
  final List<AspectData> crossAspects;
  final String progressionDate;
  final String progressionMethod;
  final double? arcDegrees;

  const ProgressionChartResult({
    required this.natal,
    required this.progressedPlanets,
    required this.crossAspects,
    required this.progressionDate,
    required this.progressionMethod,
    this.arcDegrees,
  });

  factory ProgressionChartResult.fromJson(Map<String, dynamic> json) {
    final natalJson =
        (json['natal_chart'] ?? json['natal']) as Map<String, dynamic>;
    return ProgressionChartResult(
      natal: ChartData.fromJson(natalJson),
      progressedPlanets: (json['progressed_planets'] as List<dynamic>)
          .map((e) => PlanetData.fromJson(e as Map<String, dynamic>))
          .toList(),
      crossAspects: (json['cross_aspects'] as List<dynamic>)
          .map((e) => AspectData.fromJson(e as Map<String, dynamic>))
          .toList(),
      progressionDate: json['progression_date'] as String,
      progressionMethod: json['progression_method'] as String,
      arcDegrees: (json['arc_degrees'] as num?)?.toDouble(),
    );
  }
}

class ReturnChartResult extends ChartResult {
  final ChartData natal;
  final ChartData returnChart;
  final String returnDatetime;
  final int? returnYear;
  final int? returnNumber;

  const ReturnChartResult({
    required this.natal,
    required this.returnChart,
    required this.returnDatetime,
    this.returnYear,
    this.returnNumber,
  });

  factory ReturnChartResult.fromJson(Map<String, dynamic> json) {
    final natalJson =
        (json['natal_chart'] ?? json['natal']) as Map<String, dynamic>;
    // Rust serde renames return_chart to "return"; Python golden uses "return_chart"
    final returnJson =
        (json['return_chart'] ?? json['return']) as Map<String, dynamic>;
    return ReturnChartResult(
      natal: ChartData.fromJson(natalJson),
      returnChart: ChartData.fromJson(returnJson),
      returnDatetime: json['return_datetime'] as String,
      returnYear: json['return_year'] as int?,
      returnNumber: json['return_number'] as int?,
    );
  }
}

class SynastryPerson {
  final String name;
  final ChartData chart;

  const SynastryPerson({required this.name, required this.chart});
}

class SynastryChartResult extends ChartResult {
  final SynastryPerson person1;
  final SynastryPerson person2;
  final List<AspectData> crossAspects;
  final HouseOverlays houseOverlays;

  const SynastryChartResult({
    required this.person1,
    required this.person2,
    required this.crossAspects,
    required this.houseOverlays,
  });

  factory SynastryChartResult.fromJson(Map<String, dynamic> json) {
    // Support both Rust serde (nested person1: {name, chart}) and
    // Python golden (flat person1_name, person1_chart) formats
    final SynastryPerson p1;
    final SynastryPerson p2;
    if (json.containsKey('person1_name')) {
      // Python golden data format (flat)
      p1 = SynastryPerson(
        name: json['person1_name'] as String,
        chart:
            ChartData.fromJson(json['person1_chart'] as Map<String, dynamic>),
      );
      p2 = SynastryPerson(
        name: json['person2_name'] as String,
        chart:
            ChartData.fromJson(json['person2_chart'] as Map<String, dynamic>),
      );
    } else {
      // Rust serde format (nested)
      final p1Json = json['person1'] as Map<String, dynamic>;
      final p2Json = json['person2'] as Map<String, dynamic>;
      p1 = SynastryPerson(
        name: p1Json['name'] as String,
        chart: ChartData.fromJson(p1Json['chart'] as Map<String, dynamic>),
      );
      p2 = SynastryPerson(
        name: p2Json['name'] as String,
        chart: ChartData.fromJson(p2Json['chart'] as Map<String, dynamic>),
      );
    }

    // House overlays: flat (Python) or nested under house_overlays (Rust)
    final HouseOverlays overlays;
    if (json.containsKey('person1_in_person2_houses')) {
      overlays = HouseOverlays.fromJson(
        person1In: json['person1_in_person2_houses'] as List<dynamic>,
        person2In: json['person2_in_person1_houses'] as List<dynamic>,
      );
    } else {
      final ho = json['house_overlays'] as Map<String, dynamic>;
      overlays = HouseOverlays.fromJson(
        person1In: ho['person1_in_person2_houses'] as List<dynamic>,
        person2In: ho['person2_in_person1_houses'] as List<dynamic>,
      );
    }

    return SynastryChartResult(
      person1: p1,
      person2: p2,
      crossAspects: (json['cross_aspects'] as List<dynamic>)
          .map((e) => AspectData.fromJson(e as Map<String, dynamic>))
          .toList(),
      houseOverlays: overlays,
    );
  }
}
