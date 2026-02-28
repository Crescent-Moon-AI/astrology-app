enum SpreadType {
  single('single', 'Single Card', '单牌', 1),
  threeCard('three_card', 'Three Card', '三牌阵', 3),
  loveSpread('love_spread', 'Love Spread', '爱情牌阵', 5),
  celticCross('celtic_cross', 'Celtic Cross', '凯尔特十字', 10);

  const SpreadType(this.value, this.nameEN, this.nameZH, this.cardCount);
  final String value;
  final String nameEN;
  final String nameZH;
  final int cardCount;

  static SpreadType fromValue(String value) => SpreadType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => SpreadType.threeCard,
      );
}
