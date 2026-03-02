enum MeihuaState {
  selectMethod('select_method'),
  input('input'),
  calculating('calculating'),
  revealed('revealed'),
  reading('reading');

  const MeihuaState(this.value);
  final String value;

  static MeihuaState fromValue(String value) => MeihuaState.values.firstWhere(
    (e) => e.value == value,
    orElse: () => MeihuaState.selectMethod,
  );
}
