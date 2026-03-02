enum RuneRitualState {
  selectSpread('select_spread'),
  drawing('drawing'),
  revealing('revealing'),
  reading('reading'),
  completed('completed'),
  cancelled('cancelled');

  const RuneRitualState(this.value);
  final String value;

  static RuneRitualState fromValue(String value) =>
      RuneRitualState.values.firstWhere(
        (e) => e.value == value,
        orElse: () => RuneRitualState.selectSpread,
      );
}
