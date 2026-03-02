enum RuneSpreadType {
  single('single', 'Single Rune', '单符文', 1),
  threeRune('three_rune', 'Three Rune', '三符文阵', 3),
  fiveRuneCross('five_rune_cross', 'Five Rune Cross', '五符文十字', 5);

  const RuneSpreadType(this.value, this.nameEN, this.nameZH, this.runeCount);
  final String value;
  final String nameEN;
  final String nameZH;
  final int runeCount;

  static RuneSpreadType fromValue(String value) =>
      RuneSpreadType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => RuneSpreadType.threeRune,
      );
}
