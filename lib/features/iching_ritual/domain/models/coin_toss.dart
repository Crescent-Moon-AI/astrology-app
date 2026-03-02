class CoinToss {
  final List<bool> coins; // true=head(yang/3), false=tail(yin/2)
  final int sum; // 6,7,8,9
  final bool isYang; // sum is odd (7,9)
  final bool isMoving; // sum is 6 or 9

  const CoinToss({
    required this.coins,
    required this.sum,
    required this.isYang,
    required this.isMoving,
  });

  factory CoinToss.fromCoins(List<bool> coins) {
    final sum = coins.fold<int>(0, (acc, c) => acc + (c ? 3 : 2));
    return CoinToss(
      coins: coins,
      sum: sum,
      isYang: sum.isOdd,
      isMoving: sum == 6 || sum == 9,
    );
  }

  factory CoinToss.fromJson(Map<String, dynamic> json) {
    final coins =
        (json['coins'] as List<dynamic>?)?.map((e) => e as bool).toList() ?? [];
    final sum = json['sum'] as int? ?? 7;
    return CoinToss(
      coins: coins,
      sum: sum,
      isYang: sum.isOdd,
      isMoving: sum == 6 || sum == 9,
    );
  }
}
