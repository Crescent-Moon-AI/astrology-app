enum SpreadType {
  // ── Legacy spreads ────────────────────────────────────────────────────────
  single('single', 'Single Card', '单牌', 1, '启示', 'Insight'),
  threeCard(
    'three_card',
    'Three Card',
    '三牌阵',
    3,
    '过去/现在/未来',
    'Past/Present/Future',
  ),
  loveSpread(
    'love_spread',
    'Love Spread',
    '爱情牌阵',
    5,
    '自己/对方/关系/挑战/建议',
    'Self/Partner/Relationship/Challenge/Advice',
  ),
  celticCross(
    'celtic_cross',
    'Celtic Cross',
    '凯尔特十字',
    10,
    '全面解读',
    'Full Reading',
  ),

  // ── New spreads ───────────────────────────────────────────────────────────
  universalThree(
    'universal_three',
    'Universal Three Card',
    '万能三牌阵',
    3,
    '过去/现在/未来',
    'Past/Present/Future',
  ),
  timeFlow(
    'time_flow',
    'Time Flow',
    '时间流',
    3,
    '过去/现在/未来',
    'Past/Present/Future',
  ),
  sacredTriangle(
    'sacred_triangle',
    'Sacred Triangle',
    '圣三角',
    3,
    '现状/障碍/建议',
    'Situation/Obstacle/Advice',
  ),
  hisHerHeart(
    'his_her_heart',
    'His & Her Heart',
    '他心她心',
    3,
    '对方当前状态/对方真实想法/行动倾向',
    'Current State/True Thoughts/Action Tendency',
  ),
  secretCrush(
    'secret_crush',
    'Secret Crush',
    '暗恋牌阵',
    3,
    'TA对你的印象/指引牌/TA对你的想法',
    'Their Impression/Guide Card/Their Thoughts',
  ),
  loveTriangle(
    'love_triangle',
    'Love Triangle',
    '爱情三角',
    3,
    '你的状态/发展趋势/对方状态',
    'Your State/Development/Their State',
  ),
  trueHeart(
    'true_heart',
    'True Heart Insight',
    '真心窥探',
    3,
    '表面态度/内心想法/潜在行动',
    'Surface Attitude/Inner Thoughts/Potential Action',
  ),
  reunion(
    'reunion',
    'Reunion Assessment',
    '复合评估',
    4,
    '分手原因/双方现状/复合障碍/复合机会',
    'Breakup Reason/Current State/Obstacle/Opportunity',
  ),
  breakupDecision(
    'breakup_decision',
    'Breakup Decision',
    '分手抉择',
    4,
    '分手原因/挽留价值/分手影响/最佳选择',
    'Breakup Reason/Worth Saving/Impact/Best Choice',
  ),
  crisis(
    'crisis',
    'Crisis Management',
    '危机处理',
    4,
    '问题根源/威胁程度/对方立场/解决建议',
    'Root Cause/Threat Level/Their Stance/Solution',
  ),
  exam(
    'exam',
    'Exam Spread',
    '考试牌阵',
    3,
    '准备状态/考场发挥/结果',
    'Preparation/Performance/Result',
  ),
  career(
    'career',
    'Career Development',
    '职业发展',
    6,
    '现状/优势/障碍/方向/时机/结果',
    'State/Strengths/Obstacle/Direction/Timing/Outcome',
  ),
  lostItem(
    'lost_item',
    'Lost Item',
    '失物寻找',
    4,
    '位置方向/状态/线索/建议',
    'Location/State/Clue/Advice',
  ),
  shortFortune(
    'short_fortune',
    'Short-term Fortune',
    '短期运势',
    3,
    '近期状态/建议/发展方向',
    'Recent State/Advice/Development',
  ),
  relationship(
    'relationship',
    'Relationship Assessment',
    '关系评估',
    3,
    '你的看法/关系走向/关系质量',
    'Your View/Trajectory/Quality',
  ),
  conflict(
    'conflict',
    'Conflict Resolution',
    '化解矛盾',
    4,
    '矛盾根源/对方心态/解决方法/发展趋势',
    'Root Cause/Their Mindset/Solution/Trend',
  ),
  twoChoices(
    'two_choices',
    'Two Choices',
    '二选一',
    3,
    '现状分析/选择A结果/选择B结果',
    'Situation/Choice A/Choice B',
  );

  const SpreadType(
    this.value,
    this.nameEN,
    this.nameZH,
    this.cardCount,
    this.descZH,
    this.descEN,
  );

  final String value;
  final String nameEN;
  final String nameZH;
  final int cardCount;
  final String descZH;
  final String descEN;

  static SpreadType fromValue(String value) => SpreadType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => SpreadType.universalThree,
  );
}
