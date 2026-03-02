enum LenormandSpreadType {
  single('single', 'Single Card', '单牌', 1),
  threeCard('three_card', 'Three Card', '三牌阵', 3),
  fiveCard('five_card', 'Five Card', '五牌阵', 5),
  grandTableau('grand_tableau', 'Grand Tableau', '大牌阵', 36);

  const LenormandSpreadType(
    this.value,
    this.nameEN,
    this.nameZH,
    this.cardCount,
  );
  final String value;
  final String nameEN;
  final String nameZH;
  final int cardCount;

  static LenormandSpreadType fromValue(String value) =>
      LenormandSpreadType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => LenormandSpreadType.threeCard,
      );
}
