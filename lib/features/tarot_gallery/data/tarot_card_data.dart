import '../../tarot_ritual/domain/models/tarot_card.dart';

/// Complete deck of 78 RWS tarot cards for the gallery.
class TarotCardData {
  TarotCardData._();

  static const List<Map<String, dynamic>> _majorArcana = [
    {'id': 0, 'name': 'The Fool', 'name_zh': '愚人', 'number': 0, 'suit': '', 'arcana': 'major', 'element': 'air', 'upright_keywords': ['New Beginnings', 'Innocence', 'Adventure'], 'reversed_keywords': ['Recklessness', 'Hesitation', 'Folly'], 'upright_keywords_zh': ['新开始', '纯真', '信任', '冒险', '当下', '直觉', '潜能', '自由', '勇气', '好奇心'], 'reversed_keywords_zh': ['鲁莽', '犹豫', '愚蠢', '冲动', '逃避', '不负责任'], 'image_key': 'major_00_fool'},
    {'id': 1, 'name': 'The Magician', 'name_zh': '魔术师', 'number': 1, 'suit': '', 'arcana': 'major', 'element': 'air', 'upright_keywords': ['Willpower', 'Manifestation', 'Skill'], 'reversed_keywords': ['Manipulation', 'Trickery', 'Wasted Talent'], 'upright_keywords_zh': ['创造力', '意志', '技巧', '自信', '行动力'], 'reversed_keywords_zh': ['欺骗', '浪费', '操纵', '犹豫不决'], 'image_key': 'major_01_magician'},
    {'id': 2, 'name': 'The High Priestess', 'name_zh': '女祭司', 'number': 2, 'suit': '', 'arcana': 'major', 'element': 'water', 'upright_keywords': ['Intuition', 'Mystery', 'Inner Voice'], 'reversed_keywords': ['Secrets', 'Disconnection', 'Confusion'], 'upright_keywords_zh': ['直觉', '智慧', '神秘', '内在之声', '潜意识'], 'reversed_keywords_zh': ['隐秘', '迷茫', '脱节', '压抑直觉'], 'image_key': 'major_02_high_priestess'},
    {'id': 3, 'name': 'The Empress', 'name_zh': '女皇', 'number': 3, 'suit': '', 'arcana': 'major', 'element': 'earth', 'upright_keywords': ['Abundance', 'Nurturing', 'Fertility'], 'reversed_keywords': ['Dependence', 'Neglect', 'Smothering'], 'upright_keywords_zh': ['丰盛', '滋养', '创造', '母性', '大自然'], 'reversed_keywords_zh': ['依赖', '忽视', '过度保护', '创造力受阻'], 'image_key': 'major_03_empress'},
    {'id': 4, 'name': 'The Emperor', 'name_zh': '皇帝', 'number': 4, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Authority', 'Structure', 'Leadership'], 'reversed_keywords': ['Tyranny', 'Rigidity', 'Domination'], 'upright_keywords_zh': ['权威', '稳定', '领导力', '秩序', '保护'], 'reversed_keywords_zh': ['专制', '固执', '控制欲', '缺乏纪律'], 'image_key': 'major_04_emperor'},
    {'id': 5, 'name': 'The Hierophant', 'name_zh': '教皇', 'number': 5, 'suit': '', 'arcana': 'major', 'element': 'earth', 'upright_keywords': ['Tradition', 'Guidance', 'Wisdom'], 'reversed_keywords': ['Rebellion', 'Restriction', 'Dogma'], 'upright_keywords_zh': ['传统', '引导', '信仰', '教育', '智慧'], 'reversed_keywords_zh': ['叛逆', '束缚', '教条', '挑战权威'], 'image_key': 'major_05_hierophant'},
    {'id': 6, 'name': 'The Lovers', 'name_zh': '恋人', 'number': 6, 'suit': '', 'arcana': 'major', 'element': 'air', 'upright_keywords': ['Love', 'Harmony', 'Choices'], 'reversed_keywords': ['Imbalance', 'Disharmony', 'Separation'], 'upright_keywords_zh': ['爱情', '和谐', '选择', '结合', '价值观'], 'reversed_keywords_zh': ['失衡', '分离', '不和谐', '错误选择'], 'image_key': 'major_06_lovers'},
    {'id': 7, 'name': 'The Chariot', 'name_zh': '战车', 'number': 7, 'suit': '', 'arcana': 'major', 'element': 'water', 'upright_keywords': ['Determination', 'Victory', 'Control'], 'reversed_keywords': ['Lack of Direction', 'Aggression', 'Defeat'], 'upright_keywords_zh': ['决心', '胜利', '意志力', '前进', '控制'], 'reversed_keywords_zh': ['迷失方向', '攻击性', '失败', '失控'], 'image_key': 'major_07_chariot'},
    {'id': 8, 'name': 'Strength', 'name_zh': '力量', 'number': 8, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Courage', 'Patience', 'Inner Strength'], 'reversed_keywords': ['Self-Doubt', 'Weakness', 'Insecurity'], 'upright_keywords_zh': ['勇气', '耐心', '内在力量', '温柔', '坚韧'], 'reversed_keywords_zh': ['自我怀疑', '软弱', '不安全感', '缺乏信心'], 'image_key': 'major_08_strength'},
    {'id': 9, 'name': 'The Hermit', 'name_zh': '隐士', 'number': 9, 'suit': '', 'arcana': 'major', 'element': 'earth', 'upright_keywords': ['Introspection', 'Solitude', 'Wisdom'], 'reversed_keywords': ['Isolation', 'Loneliness', 'Withdrawal'], 'upright_keywords_zh': ['内省', '独处', '智慧', '寻找真理', '指引'], 'reversed_keywords_zh': ['孤立', '孤独', '退缩', '过度封闭'], 'image_key': 'major_09_hermit'},
    {'id': 10, 'name': 'Wheel of Fortune', 'name_zh': '命运之轮', 'number': 10, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Fate', 'Cycles', 'Turning Point'], 'reversed_keywords': ['Bad Luck', 'Resistance', 'Stagnation'], 'upright_keywords_zh': ['转运', '机遇', '命运', '循环', '转折点'], 'reversed_keywords_zh': ['倒退', '阻碍', '抗拒改变', '运气不佳'], 'image_key': 'major_10_wheel_of_fortune'},
    {'id': 11, 'name': 'Justice', 'name_zh': '正义', 'number': 11, 'suit': '', 'arcana': 'major', 'element': 'air', 'upright_keywords': ['Fairness', 'Truth', 'Accountability'], 'reversed_keywords': ['Injustice', 'Dishonesty', 'Bias'], 'upright_keywords_zh': ['公正', '真理', '责任', '平衡', '因果'], 'reversed_keywords_zh': ['不公', '欺骗', '偏见', '逃避责任'], 'image_key': 'major_11_justice'},
    {'id': 12, 'name': 'The Hanged Man', 'name_zh': '倒吊人', 'number': 12, 'suit': '', 'arcana': 'major', 'element': 'water', 'upright_keywords': ['Surrender', 'New Perspective', 'Pause'], 'reversed_keywords': ['Stalling', 'Resistance', 'Indecision'], 'upright_keywords_zh': ['臣服', '新视角', '暂停', '牺牲', '放下'], 'reversed_keywords_zh': ['拖延', '抗拒', '优柔寡断', '无谓牺牲'], 'image_key': 'major_12_hanged_man'},
    {'id': 13, 'name': 'Death', 'name_zh': '死神', 'number': 13, 'suit': '', 'arcana': 'major', 'element': 'water', 'upright_keywords': ['Transformation', 'Endings', 'Renewal'], 'reversed_keywords': ['Fear of Change', 'Stagnation', 'Decay'], 'upright_keywords_zh': ['转变', '结束', '重生', '新陈代谢', '释放'], 'reversed_keywords_zh': ['恐惧改变', '停滞', '拒绝放手', '腐朽'], 'image_key': 'major_13_death'},
    {'id': 14, 'name': 'Temperance', 'name_zh': '节制', 'number': 14, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Balance', 'Moderation', 'Patience'], 'reversed_keywords': ['Excess', 'Imbalance', 'Impatience'], 'upright_keywords_zh': ['平衡', '节制', '耐心', '和谐', '疗愈'], 'reversed_keywords_zh': ['过度', '失衡', '急躁', '缺乏节制'], 'image_key': 'major_14_temperance'},
    {'id': 15, 'name': 'The Devil', 'name_zh': '恶魔', 'number': 15, 'suit': '', 'arcana': 'major', 'element': 'earth', 'upright_keywords': ['Bondage', 'Temptation', 'Shadow Self'], 'reversed_keywords': ['Liberation', 'Breaking Free', 'Detachment'], 'upright_keywords_zh': ['束缚', '诱惑', '欲望', '阴暗面', '依赖'], 'reversed_keywords_zh': ['解放', '挣脱', '超脱', '克服诱惑'], 'image_key': 'major_15_devil'},
    {'id': 16, 'name': 'The Tower', 'name_zh': '塔', 'number': 16, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Sudden Change', 'Upheaval', 'Revelation'], 'reversed_keywords': ['Avoidance', 'Delayed Disaster', 'Fear of Change'], 'upright_keywords_zh': ['突变', '崩塌', '觉醒', '毁灭与重建', '真相'], 'reversed_keywords_zh': ['逃避', '灾难延迟', '恐惧改变', '内心动荡'], 'image_key': 'major_16_tower'},
    {'id': 17, 'name': 'The Star', 'name_zh': '星星', 'number': 17, 'suit': '', 'arcana': 'major', 'element': 'air', 'upright_keywords': ['Hope', 'Inspiration', 'Serenity'], 'reversed_keywords': ['Despair', 'Disconnection', 'Lack of Faith'], 'upright_keywords_zh': ['希望', '灵感', '宁静', '信念', '治愈'], 'reversed_keywords_zh': ['失望', '迷失', '缺乏信心', '绝望'], 'image_key': 'major_17_star'},
    {'id': 18, 'name': 'The Moon', 'name_zh': '月亮', 'number': 18, 'suit': '', 'arcana': 'major', 'element': 'water', 'upright_keywords': ['Illusion', 'Intuition', 'Subconscious'], 'reversed_keywords': ['Clarity', 'Release of Fear', 'Truth'], 'upright_keywords_zh': ['幻觉', '直觉', '潜意识', '恐惧', '梦境'], 'reversed_keywords_zh': ['清明', '释放恐惧', '真相', '走出迷雾'], 'image_key': 'major_18_moon'},
    {'id': 19, 'name': 'The Sun', 'name_zh': '太阳', 'number': 19, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Joy', 'Success', 'Vitality'], 'reversed_keywords': ['Inner Child Blocked', 'Overconfidence', 'Sadness'], 'upright_keywords_zh': ['喜悦', '成功', '活力', '光明', '自信'], 'reversed_keywords_zh': ['压抑', '过度自信', '悲伤', '活力缺失'], 'image_key': 'major_19_sun'},
    {'id': 20, 'name': 'Judgement', 'name_zh': '审判', 'number': 20, 'suit': '', 'arcana': 'major', 'element': 'fire', 'upright_keywords': ['Rebirth', 'Calling', 'Absolution'], 'reversed_keywords': ['Self-Doubt', 'Refusal', 'Harsh Judgement'], 'upright_keywords_zh': ['重生', '召唤', '觉醒', '审判', '宽恕'], 'reversed_keywords_zh': ['自我怀疑', '拒绝', '严苛评判', '逃避反省'], 'image_key': 'major_20_judgement'},
    {'id': 21, 'name': 'The World', 'name_zh': '世界', 'number': 21, 'suit': '', 'arcana': 'major', 'element': 'earth', 'upright_keywords': ['Completion', 'Achievement', 'Wholeness'], 'reversed_keywords': ['Incompletion', 'Shortcut', 'Emptiness'], 'upright_keywords_zh': ['完成', '成就', '圆满', '旅程终点', '整合'], 'reversed_keywords_zh': ['未完成', '空虚', '捷径', '缺乏闭合'], 'image_key': 'major_21_world'},
  ];

  static List<Map<String, dynamic>> _generateMinorSuit(String suit, String suitZh, String element, int idStart) {
    const names = ['Ace', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Page', 'Knight', 'Queen', 'King'];
    const namesZh = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '侍从', '骑士', '王后', '国王'];

    // Generic upright/reversed keywords per card for Minor Arcana
    const uprightByIndex = [
      ['新机会', '潜力', '开端'],
      ['平衡', '合作', '联结'],
      ['创造', '成长', '团队'],
      ['稳定', '休息', '保守'],
      ['冲突', '损失', '竞争'],
      ['慷慨', '和谐', '胜利'],
      ['坚持', '挑战', '自省'],
      ['速度', '变化', '行动'],
      ['独立', '坚韧', '警惕'],
      ['圆满', '承担', '传承'],
      ['好奇', '学习', '探索'],
      ['行动', '冒险', '追求'],
      ['直觉', '温柔', '智慧'],
      ['领导', '权威', '成熟'],
    ];
    const reversedByIndex = [
      ['错失', '迟疑', '潜力未发'],
      ['失衡', '分歧', '误解'],
      ['缺乏计划', '分散', '延迟'],
      ['不安', '停滞', '贪婪'],
      ['和解', '接受', '退让'],
      ['不公', '索取', '傲慢'],
      ['放弃', '焦虑', '逃避'],
      ['阻碍', '混乱', '仓促'],
      ['孤独', '多疑', '不安'],
      ['负担', '失败', '短视'],
      ['不成熟', '懒散', '缺乏方向'],
      ['鲁莽', '停滞', '冲动'],
      ['情绪化', '依赖', '不安全'],
      ['专制', '固执', '无能'],
    ];

    return List.generate(14, (i) {
      final num = (i + 1).toString().padLeft(2, '0');
      return {
        'id': idStart + i,
        'name': '${names[i]} of ${suit[0].toUpperCase()}${suit.substring(1)}',
        'name_zh': '$suitZh${namesZh[i]}',
        'number': i + 1,
        'suit': suit,
        'arcana': 'minor',
        'element': element,
        'upright_keywords': uprightByIndex[i].map((s) => s).toList(),
        'reversed_keywords': reversedByIndex[i].map((s) => s).toList(),
        'upright_keywords_zh': uprightByIndex[i],
        'reversed_keywords_zh': reversedByIndex[i],
        'image_key': 'minor_${suit}_$num',
      };
    });
  }

  static List<TarotCard> get allCards {
    final all = <Map<String, dynamic>>[
      ..._majorArcana,
      ..._generateMinorSuit('wands', '权杖', 'fire', 22),
      ..._generateMinorSuit('cups', '圣杯', 'water', 36),
      ..._generateMinorSuit('swords', '宝剑', 'air', 50),
      ..._generateMinorSuit('pentacles', '星币', 'earth', 64),
    ];
    return all
        .map((j) => TarotCard.fromJson({...j, 'orientation': 'upright'}))
        .toList();
  }

  static List<TarotCard> get majorArcanaCards =>
      allCards.where((c) => c.arcana == 'major').toList();

  static List<TarotCard> wandsCards() =>
      allCards.where((c) => c.suit == 'wands').toList();

  static List<TarotCard> cupsCards() =>
      allCards.where((c) => c.suit == 'cups').toList();

  static List<TarotCard> swordsCards() =>
      allCards.where((c) => c.suit == 'swords').toList();

  static List<TarotCard> pentaclesCards() =>
      allCards.where((c) => c.suit == 'pentacles').toList();

  /// Category definitions for gallery tabs.
  static const categories = [
    TarotCategory(id: 'major', nameZh: '大阿尔卡纳', nameEn: 'Major Arcana', icon: 0xe50a), // auto_awesome
    TarotCategory(id: 'wands', nameZh: '权杖', nameEn: 'Wands', icon: 0xf06bb), // local_fire_department
    TarotCategory(id: 'cups', nameZh: '圣杯', nameEn: 'Cups', icon: 0xe25a), // wine_bar
    TarotCategory(id: 'swords', nameZh: '宝剑', nameEn: 'Swords', icon: 0xf04be), // content_cut
    TarotCategory(id: 'pentacles', nameZh: '星币', nameEn: 'Pentacles', icon: 0xe838), // stars
  ];

  static List<TarotCard> cardsByCategory(String categoryId) {
    if (categoryId == 'major') return majorArcanaCards;
    return allCards.where((c) => c.suit == categoryId).toList();
  }
}

class TarotCategory {
  final String id;
  final String nameZh;
  final String nameEn;
  final int icon;

  const TarotCategory({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.icon,
  });
}
