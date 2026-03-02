enum LenormandRitualState {
  shuffling('shuffling'),
  pickingCards('picking_cards'),
  confirming('confirming'),
  revealing('revealing'),
  reading('reading'),
  completed('completed'),
  cancelled('cancelled');

  const LenormandRitualState(this.value);
  final String value;

  static LenormandRitualState fromValue(String value) =>
      LenormandRitualState.values.firstWhere(
        (e) => e.value == value,
        orElse: () => LenormandRitualState.shuffling,
      );
}
