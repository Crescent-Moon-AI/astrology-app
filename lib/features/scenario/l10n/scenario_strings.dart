/// Scenario i18n key → localized string map.
/// Keys come from the backend as i18n identifiers (e.g. "scenario.heartbreak.title").
const Map<String, Map<String, String>> scenarioStrings = {
  'en': {
    // Categories
    'scenario.category.love_relationship': 'Love & Relationships',
    'scenario.category.career_growth': 'Career Growth',
    'scenario.category.daily_decision': 'Daily Decisions',
    'scenario.category.personal_growth': 'Personal Growth',
    'scenario.category.social_interaction': 'Social Interaction',

    // Heartbreak
    'scenario.heartbreak.title': 'Moving Past Heartbreak',
    'scenario.heartbreak.description':
        'Find healing and clarity through the stars after a difficult breakup.',
    'scenario.heartbreak.q1': 'How can I heal from this breakup?',
    'scenario.heartbreak.q2': 'What does the universe say about my love life?',
    'scenario.heartbreak.q3': 'When will I be ready for love again?',
    'scenario.heartbreak.q4': 'What lessons can I learn from this relationship?',

    // Love Compatibility
    'scenario.love_compatibility.title': 'Love Compatibility',
    'scenario.love_compatibility.description':
        'Explore the cosmic connection between you and your partner.',
    'scenario.love_compatibility.q1':
        'Are we compatible based on our birth charts?',
    'scenario.love_compatibility.q2':
        'What strengths does our relationship have?',
    'scenario.love_compatibility.q3':
        'What challenges should we watch out for?',

    // Career
    'scenario.career.title': 'Career Direction',
    'scenario.career.description':
        'Let the stars guide your professional journey and ambitions.',
    'scenario.career.q1': 'What career path suits me best?',
    'scenario.career.q2': 'How can I advance in my current role?',
    'scenario.career.q3': "What does this year hold for my career?",

    // Job Change
    'scenario.job_change.title': 'Job Change Timing',
    'scenario.job_change.description':
        'Discover the best timing for a career transition.',
    'scenario.job_change.q1': 'Is now a good time to change jobs?',
    'scenario.job_change.q2': 'What should I look for in my next role?',
    'scenario.job_change.q3': 'How will a job change affect my life?',

    // Decision
    'scenario.decision.title': 'A Small Decision',
    'scenario.decision.description':
        'Get cosmic guidance on everyday choices and dilemmas.',
    'scenario.decision.q1': 'Should I go with option A or B?',
    'scenario.decision.q2': 'What does my intuition say about this choice?',
    'scenario.decision.q3': 'Help me weigh the pros and cons.',

    // Daily Fortune
    'scenario.daily_fortune.title': 'Daily Fortune',
    'scenario.daily_fortune.description':
        "See what the stars have in store for you today.",
    'scenario.daily_fortune.q1': "What's my horoscope for today?",
    'scenario.daily_fortune.q2': 'What should I focus on today?',
    'scenario.daily_fortune.q3': 'Any advice from the stars for today?',

    // Self
    'scenario.self.title': 'Know Yourself',
    'scenario.self.description':
        'Unlock deeper self-understanding through your natal chart.',
    'scenario.self.q1': 'What are my core personality traits?',
    'scenario.self.q2': 'What are my hidden strengths?',
    'scenario.self.q3': 'How can I grow as a person?',

    // Life Purpose
    'scenario.life_purpose.title': 'Life Purpose',
    'scenario.life_purpose.description':
        "Discover your soul's mission through astrology.",
    'scenario.life_purpose.q1': "What is my life's purpose?",
    'scenario.life_purpose.q2': 'What gives my life meaning?',
    'scenario.life_purpose.q3': 'Am I on the right path?',

    // Social
    'scenario.social.title': 'Social Moments',
    'scenario.social.description':
        'Navigate social dynamics with cosmic insight.',
    'scenario.social.q1': 'How can I improve my social connections?',
    'scenario.social.q2': 'Why do I clash with certain people?',
    'scenario.social.q3': 'How can I be a better communicator?',

    // Family Harmony
    'scenario.family_harmony.title': 'Family Harmony',
    'scenario.family_harmony.description':
        'Understand family dynamics through the stars.',
    'scenario.family_harmony.q1': 'How can I improve family relationships?',
    'scenario.family_harmony.q2':
        'Why do certain family members conflict?',
    'scenario.family_harmony.q3':
        'How can I create more harmony at home?',
  },
  'zh': {
    // Categories
    'scenario.category.love_relationship': '恋爱关系',
    'scenario.category.career_growth': '事业发展',
    'scenario.category.daily_decision': '日常决策',
    'scenario.category.personal_growth': '个人成长',
    'scenario.category.social_interaction': '社交互动',

    // Heartbreak
    'scenario.heartbreak.title': '走出心碎',
    'scenario.heartbreak.description': '在分手后通过星象找到治愈与方向。',
    'scenario.heartbreak.q1': '我该如何从这段感情中走出来？',
    'scenario.heartbreak.q2': '宇宙对我的感情生活有什么启示？',
    'scenario.heartbreak.q3': '我什么时候能准备好再次恋爱？',
    'scenario.heartbreak.q4': '这段感情教会了我什么？',

    // Love Compatibility
    'scenario.love_compatibility.title': '爱情合盘',
    'scenario.love_compatibility.description': '探索你和伴侣之间的星象缘分。',
    'scenario.love_compatibility.q1': '根据星盘，我们合适吗？',
    'scenario.love_compatibility.q2': '我们的感情有哪些优势？',
    'scenario.love_compatibility.q3': '我们应该注意哪些挑战？',

    // Career
    'scenario.career.title': '事业方向',
    'scenario.career.description': '让星象指引你的职业旅程和抱负。',
    'scenario.career.q1': '什么职业最适合我？',
    'scenario.career.q2': '如何在当前岗位上更进一步？',
    'scenario.career.q3': '今年我的事业运如何？',

    // Job Change
    'scenario.job_change.title': '跳槽时机',
    'scenario.job_change.description': '找到职业转型的最佳时机。',
    'scenario.job_change.q1': '现在是换工作的好时候吗？',
    'scenario.job_change.q2': '下一份工作我该找什么样的？',
    'scenario.job_change.q3': '换工作会对我的生活产生什么影响？',

    // Decision
    'scenario.decision.title': '日常抉择',
    'scenario.decision.description': '为日常选择和困惑获取宇宙指引。',
    'scenario.decision.q1': '我应该选 A 还是选 B？',
    'scenario.decision.q2': '我的直觉对这个选择怎么说？',
    'scenario.decision.q3': '帮我分析一下利弊。',

    // Daily Fortune
    'scenario.daily_fortune.title': '今日运势',
    'scenario.daily_fortune.description': '看看今天星象对你有什么安排。',
    'scenario.daily_fortune.q1': '我今天的运势怎么样？',
    'scenario.daily_fortune.q2': '今天我应该关注什么？',
    'scenario.daily_fortune.q3': '星象对今天有什么建议？',

    // Self
    'scenario.self.title': '认识自己',
    'scenario.self.description': '通过本命盘深入了解自己。',
    'scenario.self.q1': '我的核心性格特质是什么？',
    'scenario.self.q2': '我有哪些隐藏的优势？',
    'scenario.self.q3': '我如何才能成长为更好的自己？',

    // Life Purpose
    'scenario.life_purpose.title': '人生使命',
    'scenario.life_purpose.description': '通过占星术发现灵魂的使命。',
    'scenario.life_purpose.q1': '我人生的使命是什么？',
    'scenario.life_purpose.q2': '什么赋予了我生命的意义？',
    'scenario.life_purpose.q3': '我走在正确的路上吗？',

    // Social
    'scenario.social.title': '社交关系',
    'scenario.social.description': '用宇宙洞察力驾驭社交动态。',
    'scenario.social.q1': '如何改善我的社交关系？',
    'scenario.social.q2': '为什么我和某些人总是合不来？',
    'scenario.social.q3': '如何成为更好的沟通者？',

    // Family Harmony
    'scenario.family_harmony.title': '家庭和谐',
    'scenario.family_harmony.description': '通过星象了解家庭关系。',
    'scenario.family_harmony.q1': '如何改善家人之间的关系？',
    'scenario.family_harmony.q2': '为什么家庭成员之间会有矛盾？',
    'scenario.family_harmony.q3': '如何在家中创造更多和谐？',
  },
};

/// Resolve a backend i18n key to a localized string.
/// Falls back to the key itself if no translation is found.
String resolveScenarioKey(String key, String locale) {
  final lang = locale.startsWith('zh') ? 'zh' : 'en';
  return scenarioStrings[lang]?[key] ?? key;
}
