enum IChingRitualState {
  question('question'),
  tossing('tossing'),
  building('building'),
  revealing('revealing'),
  reading('reading'),
  completed('completed'),
  cancelled('cancelled');

  const IChingRitualState(this.value);
  final String value;

  static IChingRitualState fromValue(String value) =>
      IChingRitualState.values.firstWhere(
        (e) => e.value == value,
        orElse: () => IChingRitualState.question,
      );
}
