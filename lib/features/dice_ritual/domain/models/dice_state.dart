enum DiceState {
  idle('idle'),
  rolling('rolling'),
  revealed('revealed'),
  reading('reading');

  const DiceState(this.value);
  final String value;

  static DiceState fromValue(String value) => DiceState.values.firstWhere(
    (e) => e.value == value,
    orElse: () => DiceState.idle,
  );
}
