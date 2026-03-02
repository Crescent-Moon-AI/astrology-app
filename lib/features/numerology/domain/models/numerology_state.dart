enum NumerologyState {
  input('input'),
  calculating('calculating'),
  revealed('revealed'),
  reading('reading');

  const NumerologyState(this.value);
  final String value;

  static NumerologyState fromValue(String value) => NumerologyState.values
      .firstWhere((e) => e.value == value, orElse: () => NumerologyState.input);
}
