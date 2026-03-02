class Trigram {
  final int number;
  final String name;
  final String nameZh;
  final String symbol;
  final String element;

  const Trigram({
    required this.number,
    required this.name,
    required this.nameZh,
    required this.symbol,
    required this.element,
  });

  factory Trigram.fromJson(Map<String, dynamic> json) {
    return Trigram(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameZh: json['name_zh'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      element: json['element'] as String? ?? '',
    );
  }

  static const List<Trigram> all = [
    Trigram(
      number: 1,
      name: 'Qian',
      nameZh: '乾',
      symbol: '\u2630',
      element: 'Heaven',
    ),
    Trigram(
      number: 2,
      name: 'Kun',
      nameZh: '坤',
      symbol: '\u2637',
      element: 'Earth',
    ),
    Trigram(
      number: 3,
      name: 'Zhen',
      nameZh: '震',
      symbol: '\u2633',
      element: 'Thunder',
    ),
    Trigram(
      number: 4,
      name: 'Xun',
      nameZh: '巽',
      symbol: '\u2634',
      element: 'Wind',
    ),
    Trigram(
      number: 5,
      name: 'Kan',
      nameZh: '坎',
      symbol: '\u2635',
      element: 'Water',
    ),
    Trigram(
      number: 6,
      name: 'Li',
      nameZh: '离',
      symbol: '\u2632',
      element: 'Fire',
    ),
    Trigram(
      number: 7,
      name: 'Gen',
      nameZh: '艮',
      symbol: '\u2636',
      element: 'Mountain',
    ),
    Trigram(
      number: 8,
      name: 'Dui',
      nameZh: '兑',
      symbol: '\u2631',
      element: 'Lake',
    ),
  ];

  static Trigram fromNumber(int number) =>
      all.firstWhere((t) => t.number == number, orElse: () => all[0]);
}
