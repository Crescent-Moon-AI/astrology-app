enum RitualState {
  shuffling('shuffling'),
  pickingCards('picking_cards'),
  confirming('confirming'),
  revealing('revealing'),
  reading('reading'),
  completed('completed'),
  cancelled('cancelled'),
  expired('expired');

  const RitualState(this.value);
  final String value;

  static RitualState fromValue(String value) => RitualState.values.firstWhere(
        (e) => e.value == value,
        orElse: () => RitualState.shuffling,
      );
}
