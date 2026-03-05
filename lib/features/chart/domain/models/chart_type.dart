enum ChartType {
  natal,
  transit,
  secondaryProgression,
  solarArc,
  solarReturn,
  lunarReturn,
  synastry;

  String get labelKey {
    return switch (this) {
      ChartType.natal => 'chartNatal',
      ChartType.transit => 'chartTransit',
      ChartType.secondaryProgression => 'chartSecondaryProgression',
      ChartType.solarArc => 'chartSolarArc',
      ChartType.solarReturn => 'chartSolarReturn',
      ChartType.lunarReturn => 'chartLunarReturn',
      ChartType.synastry => 'chartSynastry',
    };
  }
}
