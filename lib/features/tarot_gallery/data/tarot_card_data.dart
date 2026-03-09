import 'package:flutter/widgets.dart';

import '../../tarot_ritual/domain/models/tarot_card.dart';

/// Complete deck of 78 RWS tarot cards for the gallery.
class TarotCardData {
  TarotCardData._();

  static const List<Map<String, dynamic>> _majorArcana = [
    {
      'id': 0,
      'name': 'The Fool',
      'name_zh': '愚人',
      'number': 0,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['New Beginnings', 'Innocence', 'Adventure'],
      'reversed_keywords': ['Recklessness', 'Hesitation', 'Folly'],
      'upright_keywords_zh': [
        '新开始',
        '纯真',
        '信任',
        '冒险',
        '当下',
        '直觉',
        '潜能',
        '自由',
        '勇气',
        '好奇心',
      ],
      'reversed_keywords_zh': ['鲁莽', '犹豫', '愚蠢', '冲动', '逃避', '不负责任'],
      'image_key': 'major_00_fool',
      'upright_meaning_zh':
          '你站在人生的崭新起点，带着对世界的好奇与纯真踏上旅途。放下顾虑，信任直觉，此刻的勇气将引领你走向意想不到的美好冒险。每一步都是全新的可能，不要被过去的经验束缚，以开放的心态迎接未知的一切。',
      'reversed_meaning_zh':
          '鲁莽与冲动正将你推向危险的边缘，过度的天真也可能成为你的绊脚石。请在行动前三思，是时候承担起应有的责任，而非逃避现实。检视是否因为恐惧而裹足不前，或因为无知而做出轻率的决定。',
    },
    {
      'id': 1,
      'name': 'The Magician',
      'name_zh': '魔术师',
      'number': 1,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['Willpower', 'Manifestation', 'Skill'],
      'reversed_keywords': ['Manipulation', 'Trickery', 'Wasted Talent'],
      'upright_keywords_zh': ['创造力', '意志', '技巧', '自信', '行动力'],
      'reversed_keywords_zh': ['欺骗', '浪费', '操纵', '犹豫不决'],
      'image_key': 'major_01_magician',
      'upright_meaning_zh':
          '你拥有实现愿望所需的一切资源与技能，四元素齐备于桌案之上。专注意志，把握当下，创造力与行动力将助你将梦想化为现实。你是自己命运的创造者，善用手中所有，意念与行动合一。',
      'reversed_meaning_zh':
          '才能被埋没，或有人正在利用话术欺骗与操控。审视自己是否在逃避真正重要的事，还是在浪费已有的天赋与机会。警惕周围是否存在虚伪与欺诈，不要让自己的能力服务于不正当的目的。',
    },
    {
      'id': 2,
      'name': 'The High Priestess',
      'name_zh': '女祭司',
      'number': 2,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['Intuition', 'Mystery', 'Inner Voice'],
      'reversed_keywords': ['Secrets', 'Disconnection', 'Confusion'],
      'upright_keywords_zh': ['直觉', '智慧', '神秘', '内在之声', '潜意识'],
      'reversed_keywords_zh': ['隐秘', '迷茫', '脱节', '压抑直觉'],
      'image_key': 'major_02_high_priestess',
      'upright_meaning_zh':
          '内心深处有答案在等待你，静下心来倾听直觉的低语。潜意识的智慧比任何外部建议都更贴近真相，此刻不是行动的时候，而是沉淀与聆听的时机。神秘的面纱之后，隐藏着你需要知道的一切。',
      'reversed_meaning_zh':
          '你正在压制自己的直觉，或被外界的噪音遮蔽了内在的声音。秘密被隐藏，或你在面对重要问题时选择了逃避。试着回归内心的宁静，不要让恐惧阻止你看见真相，也不要忽视那些隐约的预感。',
    },
    {
      'id': 3,
      'name': 'The Empress',
      'name_zh': '女皇',
      'number': 3,
      'suit': '',
      'arcana': 'major',
      'element': 'earth',
      'upright_keywords': ['Abundance', 'Nurturing', 'Fertility'],
      'reversed_keywords': ['Dependence', 'Neglect', 'Smothering'],
      'upright_keywords_zh': ['丰盛', '滋养', '创造', '母性', '大自然'],
      'reversed_keywords_zh': ['依赖', '忽视', '过度保护', '创造力受阻'],
      'image_key': 'major_03_empress',
      'upright_meaning_zh':
          '丰盛与创造的能量环绕着你，这是播种与滋养的最佳时机。爱与自然的力量将带来丰收，无论是事业、关系还是创意项目都将蓬勃生长。照顾好自己，也关怀身边的人，母性的温柔与慷慨是你最大的力量。',
      'reversed_meaning_zh':
          '过度依赖他人或忽视自我需求正在消耗你的活力，创造力受到阻碍。也许你在关系中失去了自我，或在过度保护中窒息了他人的成长。是时候重新与大自然和内心的母性能量连接，找回滋养自己的能力。',
    },
    {
      'id': 4,
      'name': 'The Emperor',
      'name_zh': '皇帝',
      'number': 4,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Authority', 'Structure', 'Leadership'],
      'reversed_keywords': ['Tyranny', 'Rigidity', 'Domination'],
      'upright_keywords_zh': ['权威', '稳定', '领导力', '秩序', '保护'],
      'reversed_keywords_zh': ['专制', '固执', '控制欲', '缺乏纪律'],
      'image_key': 'major_04_emperor',
      'upright_meaning_zh':
          '以稳固的结构和清晰的规则建立你的王国，权威来自内心的坚定与担当。责任与纪律是通往真正自由的必经之路，制定计划并付诸执行，用稳健的步伐守护你所珍视的一切。',
      'reversed_meaning_zh':
          '控制欲过强或固执己见正在阻碍你和周围人的成长，专制带来的是反抗而非忠诚。检视是否因为恐惧失控而试图掌控一切，缺乏弹性的权威只会令人窒息，适时放手也是一种领导的智慧。',
    },
    {
      'id': 5,
      'name': 'The Hierophant',
      'name_zh': '教皇',
      'number': 5,
      'suit': '',
      'arcana': 'major',
      'element': 'earth',
      'upright_keywords': ['Tradition', 'Guidance', 'Wisdom'],
      'reversed_keywords': ['Rebellion', 'Restriction', 'Dogma'],
      'upright_keywords_zh': ['传统', '引导', '信仰', '教育', '智慧'],
      'reversed_keywords_zh': ['叛逆', '束缚', '教条', '挑战权威'],
      'image_key': 'major_05_hierophant',
      'upright_meaning_zh':
          '传统与信仰中蕴含着真正的智慧，遵循既有的道路未必是保守，而是对前人经验的尊重。寻求导师或精神引导者的帮助，在集体的价值观与仪式中找到归属感与力量，教育与学习是此刻的主题。',
      'reversed_meaning_zh':
          '教条和规则正在束缚你的灵魂，盲目服从权威使你失去了独立思考的能力。也许是时候质疑既有的体制，打破不再适合你的限制，找到属于自己的精神道路。创新与个人信仰同样值得被尊重。',
    },
    {
      'id': 6,
      'name': 'The Lovers',
      'name_zh': '恋人',
      'number': 6,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['Love', 'Harmony', 'Choices'],
      'reversed_keywords': ['Imbalance', 'Disharmony', 'Separation'],
      'upright_keywords_zh': ['爱情', '和谐', '选择', '结合', '价值观'],
      'reversed_keywords_zh': ['失衡', '分离', '不和谐', '错误选择'],
      'image_key': 'major_06_lovers',
      'upright_meaning_zh':
          '你面临一个重要的选择，这不仅关于爱情，更关乎价值观与人生方向的取舍。遵从内心，做出真诚的决定，和谐的关系建立在相互尊重与共同价值观之上。此刻的选择将深刻影响你的人生旅程。',
      'reversed_meaning_zh':
          '关系中出现裂痕，价值观的分歧正带来冲突与不和谐。重新审视你的选择，是否背离了自己真正相信的东西？也许过去的某个决定需要被重新面对，诚实地审视自己在关系中的行为与期待。',
    },
    {
      'id': 7,
      'name': 'The Chariot',
      'name_zh': '战车',
      'number': 7,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['Determination', 'Victory', 'Control'],
      'reversed_keywords': ['Lack of Direction', 'Aggression', 'Defeat'],
      'upright_keywords_zh': ['决心', '胜利', '意志力', '前进', '控制'],
      'reversed_keywords_zh': ['迷失方向', '攻击性', '失败', '失控'],
      'image_key': 'major_07_chariot',
      'upright_meaning_zh':
          '以坚定的意志驾驭生命中的对立力量，朝着目标全力前进。胜利属于那些既有激情又懂自制的人，内外的矛盾正是你前进的动力。保持专注，不被外界动摇，你有能力克服眼前的一切障碍。',
      'reversed_meaning_zh':
          '方向的迷失或内心的冲突正在分散你的力量，战车失控。暴力与强硬并非解决问题的方式，过度的攻击性只会带来更多阻力。重新找回内心的平衡与前进的方向，不要让情绪的洪流淹没你的判断。',
    },
    {
      'id': 8,
      'name': 'Strength',
      'name_zh': '力量',
      'number': 8,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Courage', 'Patience', 'Inner Strength'],
      'reversed_keywords': ['Self-Doubt', 'Weakness', 'Insecurity'],
      'upright_keywords_zh': ['勇气', '耐心', '内在力量', '温柔', '坚韧'],
      'reversed_keywords_zh': ['自我怀疑', '软弱', '不安全感', '缺乏信心'],
      'image_key': 'major_08_strength',
      'upright_meaning_zh':
          '真正的力量不是压制，而是以温柔与耐心驯服内心的野兽。你拥有超越蛮力的内在强大，慈悲与坚韧并行，以爱的力量化解恐惧与愤怒。此刻考验的是你的精神韧性，你比自己想象的更加强大。',
      'reversed_meaning_zh':
          '自我怀疑和恐惧正在削弱你的力量，内心的批判声音太过响亮。也许你正在压制情绪导致爆发，或过度放纵而失去自制。重新建立与自己内心的联系，温柔地对待自己，力量来自于接纳而非对抗。',
    },
    {
      'id': 9,
      'name': 'The Hermit',
      'name_zh': '隐士',
      'number': 9,
      'suit': '',
      'arcana': 'major',
      'element': 'earth',
      'upright_keywords': ['Introspection', 'Solitude', 'Wisdom'],
      'reversed_keywords': ['Isolation', 'Loneliness', 'Withdrawal'],
      'upright_keywords_zh': ['内省', '独处', '智慧', '寻找真理', '指引'],
      'reversed_keywords_zh': ['孤立', '孤独', '退缩', '过度封闭'],
      'image_key': 'major_09_hermit',
      'upright_meaning_zh':
          '退出喧嚣，在独处与内省中寻找深刻的智慧。隐士手中的灯笼将为迷途者指引方向，而这份智慧来自于对内在真理的深刻探索。此刻需要的是独自前行，拒绝外界干扰，聆听灵魂的声音。',
      'reversed_meaning_zh':
          '过度的孤立正在演变为有害的孤独与封闭，你在切断与外界的联系。也许你在逃避社会责任，或拒绝接受他人伸出的援手。独处与孤立之间有重要的区别，是时候重新走出来，与他人重新建立连接。',
    },
    {
      'id': 10,
      'name': 'Wheel of Fortune',
      'name_zh': '命运之轮',
      'number': 10,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Fate', 'Cycles', 'Turning Point'],
      'reversed_keywords': ['Bad Luck', 'Resistance', 'Stagnation'],
      'upright_keywords_zh': ['转运', '机遇', '命运', '循环', '转折点'],
      'reversed_keywords_zh': ['倒退', '阻碍', '抗拒改变', '运气不佳'],
      'image_key': 'major_10_wheel_of_fortune',
      'upright_meaning_zh':
          '命运的转轮正在转动，好运与机遇即将到来。接受变化的循环，顺势而为，此刻正是人生的重要转折点。万事皆有因果，过去的种因正在结果，宇宙的力量正朝着有利的方向运转，把握这股东风。',
      'reversed_meaning_zh':
          '变化遭遇阻力，或坏运气暂时占据上风，轮子转向了不利的方向。抗拒命运的流动只会带来更多痛苦，学会放下对结果的执著。审视自己的行为模式，是否在重复同样的错误？改变始于内心的觉悟。',
    },
    {
      'id': 11,
      'name': 'Justice',
      'name_zh': '正义',
      'number': 11,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['Fairness', 'Truth', 'Accountability'],
      'reversed_keywords': ['Injustice', 'Dishonesty', 'Bias'],
      'upright_keywords_zh': ['公正', '真理', '责任', '平衡', '因果'],
      'reversed_keywords_zh': ['不公', '欺骗', '偏见', '逃避责任'],
      'image_key': 'major_11_justice',
      'upright_meaning_zh':
          '公正将得到伸张，真相终将浮出水面。你的行为将得到公正的评判，因果法则在此刻清晰运作。做出诚实而负责任的选择，以客观和公平的心态面对眼前的情况，天平终将趋向平衡。',
      'reversed_meaning_zh':
          '不公正的裁决或欺骗正影响着当前的局势，有人在逃避应有的责任。审视自己是否在为自己的行为找借口，或是否有重要的真相被刻意隐藏。偏见与不诚实终将带来更大的麻烦，及早面对才是上策。',
    },
    {
      'id': 12,
      'name': 'The Hanged Man',
      'name_zh': '倒吊人',
      'number': 12,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['Surrender', 'New Perspective', 'Pause'],
      'reversed_keywords': ['Stalling', 'Resistance', 'Indecision'],
      'upright_keywords_zh': ['臣服', '新视角', '暂停', '牺牲', '放下'],
      'reversed_keywords_zh': ['拖延', '抗拒', '优柔寡断', '无谓牺牲'],
      'image_key': 'major_12_hanged_man',
      'upright_meaning_zh':
          '暂停前行，换个角度看世界。有时候，主动放弃控制、接受等待，才是真正的智慧。倒吊人的姿态带来全新的视角与深刻的领悟，牺牲当下的舒适将为你带来更深远的收获，放下执念才能看见真相。',
      'reversed_meaning_zh':
          '优柔寡断与无谓的等待正在消耗宝贵的时间，你在用"暂停"来逃避真正需要做的决定。真正的放下不是被动地拖延，审视自己是否在以牺牲之名行逃避之实，是时候做出行动了。',
    },
    {
      'id': 13,
      'name': 'Death',
      'name_zh': '死神',
      'number': 13,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['Transformation', 'Endings', 'Renewal'],
      'reversed_keywords': ['Fear of Change', 'Stagnation', 'Decay'],
      'upright_keywords_zh': ['转变', '结束', '重生', '新陈代谢', '释放'],
      'reversed_keywords_zh': ['恐惧改变', '停滞', '拒绝放手', '腐朽'],
      'image_key': 'major_13_death',
      'upright_meaning_zh':
          '旧的阶段即将走向终结，为新的开始让路，这是必然而神圣的转变。不必恐惧这场蜕变，死亡只是循环的一部分，释放过去才能拥抱全新的未来。告别虽然痛苦，却是成长不可或缺的代价。',
      'reversed_meaning_zh':
          '你正在抗拒必要的改变，紧紧抓着已经死去的事物不放手。停滞正在演变为腐朽，恐惧改变只会让痛苦延续得更久。放手才是真正的解脱，越早接受这场终结，越早能够迎来真正的新生。',
    },
    {
      'id': 14,
      'name': 'Temperance',
      'name_zh': '节制',
      'number': 14,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Balance', 'Moderation', 'Patience'],
      'reversed_keywords': ['Excess', 'Imbalance', 'Impatience'],
      'upright_keywords_zh': ['平衡', '节制', '耐心', '和谐', '疗愈'],
      'reversed_keywords_zh': ['过度', '失衡', '急躁', '缺乏节制'],
      'image_key': 'major_14_temperance',
      'upright_meaning_zh':
          '在对立中寻找和谐，以耐心调配生命中的各种元素。天使将水缓缓倒流，象征着疗愈与整合的过程，治愈需要时间，急不得。平衡是通往内在平静的唯一路径，让一切有机地融合，不强求，顺其自然。',
      'reversed_meaning_zh':
          '过度与失衡正在破坏你的生活节奏，冲动和极端使事情失控。也许你在某方面过度放纵，或在追求目标时走向了极端。回归节制，让自己在身心两方面重新找到平衡，耐心是此刻最需要培养的品质。',
    },
    {
      'id': 15,
      'name': 'The Devil',
      'name_zh': '恶魔',
      'number': 15,
      'suit': '',
      'arcana': 'major',
      'element': 'earth',
      'upright_keywords': ['Bondage', 'Temptation', 'Shadow Self'],
      'reversed_keywords': ['Liberation', 'Breaking Free', 'Detachment'],
      'upright_keywords_zh': ['束缚', '诱惑', '欲望', '阴暗面', '依赖'],
      'reversed_keywords_zh': ['解放', '挣脱', '超脱', '克服诱惑'],
      'image_key': 'major_15_devil',
      'upright_meaning_zh':
          '你意识到了束缚你的枷锁，无论是物质执着、恶习还是有害关系。认清阴暗面是解放的第一步，那些你以为无法摆脱的锁链，其实没有你想象的那么牢固。勇敢直视内心的阴影，真正的自由在等待你。',
      'reversed_meaning_zh':
          '解放的时机已到，你有能力挣脱长久以来的束缚，重获自由。但需警惕新的诱惑，真正的自由来自内心深处的觉醒，而非仅仅逃离外部环境。彻底审视那些令你上瘾或依赖的模式，从根源处改变。',
    },
    {
      'id': 16,
      'name': 'The Tower',
      'name_zh': '塔',
      'number': 16,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Sudden Change', 'Upheaval', 'Revelation'],
      'reversed_keywords': ['Avoidance', 'Delayed Disaster', 'Fear of Change'],
      'upright_keywords_zh': ['突变', '崩塌', '觉醒', '毁灭与重建', '真相'],
      'reversed_keywords_zh': ['逃避', '灾难延迟', '恐惧改变', '内心动荡'],
      'image_key': 'major_16_tower',
      'upright_meaning_zh':
          '建立在虚假基础上的结构正在崩塌，这是一场必要而深刻的清算。虽然突如其来的改变令人痛苦，但倒塌之后才有重建真实之物的空间。闪电击碎了幻觉，真相在混乱中显现，接受这场破坏，它是进化的序章。',
      'reversed_meaning_zh':
          '灾难被推迟，但根本问题仍未解决，内心的动荡正在积聚能量。也许你在竭力避免必要的改变与面对，但压抑只会让爆发来得更猛烈。早做准备，主动面对那些令你恐惧的改变，比被动承受要好得多。',
    },
    {
      'id': 17,
      'name': 'The Star',
      'name_zh': '星星',
      'number': 17,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['Hope', 'Inspiration', 'Serenity'],
      'reversed_keywords': ['Despair', 'Disconnection', 'Lack of Faith'],
      'upright_keywords_zh': ['希望', '灵感', '宁静', '信念', '治愈'],
      'reversed_keywords_zh': ['失望', '迷失', '缺乏信心', '绝望'],
      'image_key': 'major_17_star',
      'upright_meaning_zh':
          '经历风雨之后，希望之光再次照耀。你与宇宙的能量深深相连，疗愈正在悄然发生。对未来保持信心与美好的期望，灵感正向你涌来，此刻是重新找回自我价值、疗愈过去伤痛的最佳时机。',
      'reversed_meaning_zh':
          '绝望与幻灭正在遮蔽希望之光，近期的挫折让你失去了对未来的信心。也许你感到与自己的灵魂或更高力量断开了连接，试着重新与内心的希望连接，疗愈需要时间与耐心，不要放弃对美好的相信。',
    },
    {
      'id': 18,
      'name': 'The Moon',
      'name_zh': '月亮',
      'number': 18,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['Illusion', 'Intuition', 'Subconscious'],
      'reversed_keywords': ['Clarity', 'Release of Fear', 'Truth'],
      'upright_keywords_zh': ['幻觉', '直觉', '潜意识', '恐惧', '梦境'],
      'reversed_keywords_zh': ['清明', '释放恐惧', '真相', '走出迷雾'],
      'image_key': 'major_18_moon',
      'upright_meaning_zh':
          '现实的表象之下隐藏着幻觉与恐惧，事物并非表面看起来那样。倾听潜意识传来的信号与梦境的启示，在不确定与迷雾中前行，直觉将带你穿越黑暗。不要逃避内心的恐惧，直视它才能化解它。',
      'reversed_meaning_zh':
          '迷雾开始消散，真相逐渐浮出水面，清明即将到来。那些长久以来困扰你的恐惧与焦虑正在减弱，你有能力走出内心的黑暗与混沌。过去的幻觉与谎言将被揭穿，用理性和清醒重新审视现实。',
    },
    {
      'id': 19,
      'name': 'The Sun',
      'name_zh': '太阳',
      'number': 19,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Joy', 'Success', 'Vitality'],
      'reversed_keywords': ['Inner Child Blocked', 'Overconfidence', 'Sadness'],
      'upright_keywords_zh': ['喜悦', '成功', '活力', '光明', '自信'],
      'reversed_keywords_zh': ['压抑', '过度自信', '悲伤', '活力缺失'],
      'image_key': 'major_19_sun',
      'upright_meaning_zh':
          '光明、喜悦与成功正在向你涌来，阳光驱散了所有阴霾。万事俱备，活力充沛，此刻是庆祝生命、展现真实自我的美好时机。孩童般的纯真与喜悦是你最宝贵的财富，与他人分享你的光芒吧。',
      'reversed_meaning_zh':
          '阴云暂时遮住了阳光，喜悦感有所减弱，内心小孩的活力被压抑。也许过度自信导致了失误，或负面情绪正在蒙蔽你对生活美好的感知。重新找回内心的孩童之光，快乐就在你的内心深处等待。',
    },
    {
      'id': 20,
      'name': 'Judgement',
      'name_zh': '审判',
      'number': 20,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['Rebirth', 'Calling', 'Absolution'],
      'reversed_keywords': ['Self-Doubt', 'Refusal', 'Harsh Judgement'],
      'upright_keywords_zh': ['重生', '召唤', '觉醒', '审判', '宽恕'],
      'reversed_keywords_zh': ['自我怀疑', '拒绝', '严苛评判', '逃避反省'],
      'image_key': 'major_20_judgement',
      'upright_meaning_zh':
          '觉醒的号角已经吹响，是时候正视过去、接受审判并走向新生了。接受内心深处的召唤，放下背负已久的负担，勇敢地迈向人生的全新篇章。宽恕自己与他人，清算带来的是解脱，而非惩罚。',
      'reversed_meaning_zh':
          '自我否定和逃避阻碍了你的觉醒，你在对自己或他人做出过于严苛的评判。也许你拒绝听从内心的召唤，或害怕直面过去的行为。以慈悲之心原谅自己，不完美是人类的共同特质，放下批判，重新出发。',
    },
    {
      'id': 21,
      'name': 'The World',
      'name_zh': '世界',
      'number': 21,
      'suit': '',
      'arcana': 'major',
      'element': 'earth',
      'upright_keywords': ['Completion', 'Achievement', 'Wholeness'],
      'reversed_keywords': ['Incompletion', 'Shortcut', 'Emptiness'],
      'upright_keywords_zh': ['完成', '成就', '圆满', '旅程终点', '整合'],
      'reversed_keywords_zh': ['未完成', '空虚', '捷径', '缺乏闭合'],
      'image_key': 'major_21_world',
      'upright_meaning_zh':
          '旅程圆满完成，你达到了一个重要的人生成就与里程碑。这份整合带来内心的圆融与完整，此刻值得好好庆祝。同时，每一个终点都是新循环的起点，带着这份完整感，你已准备好踏上下一段旅程。',
      'reversed_meaning_zh':
          '旅程尚未真正完成，有某个重要的环节被忽略或刻意回避。也许你在走捷径，或错过了这段经历中应有的深刻领悟。回头检视那些未竟之事，让这段旅程真正画上完整的句号，才能带着圆满开启新篇章。',
    },
  ];

  static List<Map<String, dynamic>> _generateMinorSuit(
    String suit,
    String suitZh,
    String element,
    int idStart,
  ) {
    const names = [
      'Ace',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Page',
      'Knight',
      'Queen',
      'King',
    ];
    const namesZh = [
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
      '侍从',
      '骑士',
      '王后',
      '国王',
    ];

    // Suit-specific flavor text
    final suitUpright = switch (suit) {
      'wands' => '权杖牌代表行动与热情，',
      'cups' => '圣杯牌代表情感与关系，',
      'swords' => '宝剑牌代表思维与真相，',
      'pentacles' => '星币牌代表物质与现实，',
      _ => '',
    };
    final suitReversed = switch (suit) {
      'wands' => '当热情受阻，',
      'cups' => '当情感失衡，',
      'swords' => '当思维混乱，',
      'pentacles' => '当物质受困，',
      _ => '',
    };

    const uprightMeaningTemplate = [
      '新的能量与可能性正在涌现，这是一个充满潜力的崭新开端。把握这股纯粹的力量，让它引领你踏上新的旅程。',
      '你正站在两个方向的交叉点，需要在合作与独立之间找到平衡。与他人的联结将带来意想不到的收获。',
      '创造力与协作正在产生美好的果实，团队的力量大于个人。分享你的成果，在集体中寻找归属与成长。',
      '稳定与安全感是此刻的主题，是时候停下来休息与巩固已有的成就。不要急于前进，先夯实基础。',
      '挑战与冲突考验着你的韧性，这是成长不可避免的一部分。以开放的心态面对困难，它们将使你更加强大。',
      '慷慨与和谐的能量围绕着你，给予与接受达到了美好的平衡。分享你的丰盛，善意将以倍增的方式回报。',
      '坚持与内省是此刻的关键词，评估自己的处境并保持战略性的耐心。机会终将在坚守中浮现。',
      '快速的行动与变化正在展开，技能与效率是你的优势。保持专注，让勤奋与精准引领你走向成功。',
      '你已接近某个重要目标的完成，独立与坚韧是你走到今天的力量。最后的坚持将带来丰厚的回报。',
      '一个重要的阶段即将圆满完成，成就与责任并肩而行。承担传承与分享的责任，让这份丰盛流向更多人。',
      '好奇心与学习的热情驱动着你探索新领域，新的消息或机会正在到来。保持开放，每一次探索都是成长的养分。',
      '充满活力的行动与冒险精神引领你追求心中所求，勇往直前是你的本色。以热忱与勇气奔向你的目标。',
      '你已掌握了这一领域的深刻智慧，以温柔与直觉滋养身边的人。你的成熟与洞察力是他人最宝贵的支柱。',
      '作为这一领域的成熟领导者，你的权威来自于丰富的经验与稳健的判断。以智慧与公正引领前行。',
    ];
    const reversedMeaningTemplate = [
      '新机会被错失，或你在面对改变时犹豫不决。停滞取代了应有的前进动力，审视是什么阻碍了你迈出第一步。',
      '失衡与分歧正在影响你与他人的关系，沟通出现了障碍。重新审视合作的方式，找回相互理解的基础。',
      '计划缺乏协调，成果的到来被推迟。内部的分歧或外部的阻力使进展放缓，重新整合资源，明确共同目标。',
      '不安全感与过度保守阻碍了你的成长，或贪婪使你固守而不愿分享。检视是什么让你如此执着于控制。',
      '冲突的和解与接受损失是此刻的功课，抗拒只会延长痛苦。学会退让与原谅，在困境中寻找重建的机会。',
      '不公平的对待或单方面的索取破坏了关系的和谐，傲慢遮蔽了感恩的眼睛。重新找回给予与接受的平衡。',
      '焦虑与逃避取代了应有的坚持，你在面对挑战时选择了放弃。审视内心的恐惧，它是否比实际问题更大？',
      '混乱与仓促导致效率下降，计划受到阻碍。放慢节奏，重新梳理思路，有时候慢下来才能走得更快更稳。',
      '孤独与多疑正在侵蚀你的安全感，过度的谨慎使你错失了支持与机会。适当地信任他人，接受帮助不是软弱。',
      '过重的负担正在压垮你，或短视的决定使长期的努力付诸东流。放下一些不属于你的责任，重新找回平衡。',
      '不成熟与缺乏方向使机会在手中溜走，懒散和拖延消耗了你的潜力。是时候认真对待自己的成长与学习。',
      '鲁莽与冲动导致了不必要的错误，或你的行动陷入了停滞。在热情与计划之间找到平衡，才能真正前进。',
      '情绪化与依赖他人使你失去了内心的稳定，不安全感正在影响你的判断与关系。回归内心，重建自我的根基。',
      '专制与固执阻碍了领导效能，或能力的缺失使你的权威受到质疑。以谦逊和开放的态度重新赢得信任。',
    ];

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
        'upright_meaning_zh': '$suitUpright${uprightMeaningTemplate[i]}',
        'reversed_meaning_zh': '$suitReversed${reversedMeaningTemplate[i]}',
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
    TarotCategory(
      id: 'major',
      nameZh: '大阿尔卡纳',
      nameEn: 'Major Arcana',
      icon: IconData(0xe50a, fontFamily: 'MaterialIcons'),
    ), // auto_awesome
    TarotCategory(
      id: 'wands',
      nameZh: '权杖',
      nameEn: 'Wands',
      icon: IconData(0xf06bb, fontFamily: 'MaterialIcons'),
    ), // local_fire_department
    TarotCategory(
      id: 'cups',
      nameZh: '圣杯',
      nameEn: 'Cups',
      icon: IconData(0xe25a, fontFamily: 'MaterialIcons'),
    ), // wine_bar
    TarotCategory(
      id: 'swords',
      nameZh: '宝剑',
      nameEn: 'Swords',
      icon: IconData(0xf04be, fontFamily: 'MaterialIcons'),
    ), // content_cut
    TarotCategory(
      id: 'pentacles',
      nameZh: '星币',
      nameEn: 'Pentacles',
      icon: IconData(0xe838, fontFamily: 'MaterialIcons'),
    ), // stars
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
  final IconData icon;

  const TarotCategory({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.icon,
  });
}
