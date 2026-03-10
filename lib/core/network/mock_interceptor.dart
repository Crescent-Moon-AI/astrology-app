import 'package:dio/dio.dart';

/// Dio interceptor that returns mock Chinese data for all API routes.
/// Used by [main_mock.dart] to create a self-contained demo build.
class MockInterceptor extends Interceptor {
  /// In-memory tarot session store for stateful ritual flow.
  final Map<String, Map<String, dynamic>> _tarotSessions = {};

  /// In-memory rune session store.
  final Map<String, Map<String, dynamic>> _runeSessions = {};

  /// In-memory lenormand session store.
  final Map<String, Map<String, dynamic>> _lenormandSessions = {};

  /// In-memory I Ching session store.
  final Map<String, Map<String, dynamic>> _ichingSessions = {};

  static final List<Map<String, dynamic>> _mockCardPool = [
    // Major Arcana
    {
      'id': 0,
      'name': 'The Fool',
      'name_zh': '愚者',
      'number': 0,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['新开始', '冒险'],
      'reversed_keywords': ['鲁莽', '犹豫'],
      'image_key': 'major_00_fool',
    },
    {
      'id': 1,
      'name': 'The Magician',
      'name_zh': '魔术师',
      'number': 1,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['创造力', '意志'],
      'reversed_keywords': ['欺骗', '浪费'],
      'image_key': 'major_01_magician',
    },
    {
      'id': 2,
      'name': 'The High Priestess',
      'name_zh': '女祭司',
      'number': 2,
      'suit': '',
      'arcana': 'major',
      'element': 'water',
      'upright_keywords': ['直觉', '智慧'],
      'reversed_keywords': ['隐秘', '迷茫'],
      'image_key': 'major_02_high_priestess',
    },
    {
      'id': 6,
      'name': 'The Lovers',
      'name_zh': '恋人',
      'number': 6,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['爱情', '和谐'],
      'reversed_keywords': ['失衡', '分离'],
      'image_key': 'major_06_lovers',
    },
    {
      'id': 10,
      'name': 'Wheel of Fortune',
      'name_zh': '命运之轮',
      'number': 10,
      'suit': '',
      'arcana': 'major',
      'element': 'fire',
      'upright_keywords': ['转运', '机遇'],
      'reversed_keywords': ['倒退', '阻碍'],
      'image_key': 'major_10_wheel_of_fortune',
    },
    {
      'id': 17,
      'name': 'The Star',
      'name_zh': '星星',
      'number': 17,
      'suit': '',
      'arcana': 'major',
      'element': 'air',
      'upright_keywords': ['希望', '灵感'],
      'reversed_keywords': ['失望', '迷失'],
      'image_key': 'major_17_star',
    },
    // Wands
    {
      'id': 22,
      'name': 'Ace of Wands',
      'name_zh': '权杖一',
      'number': 1,
      'suit': 'wands',
      'arcana': 'minor',
      'element': 'fire',
      'upright_keywords': ['创造', '激情'],
      'reversed_keywords': ['延迟', '消沉'],
      'image_key': 'minor_wands_01',
    },
    {
      'id': 29,
      'name': 'Eight of Wands',
      'name_zh': '权杖八',
      'number': 8,
      'suit': 'wands',
      'arcana': 'minor',
      'element': 'fire',
      'upright_keywords': ['快速', '行动'],
      'reversed_keywords': ['拖延', '阻碍'],
      'image_key': 'minor_wands_08',
    },
    // Cups
    {
      'id': 36,
      'name': 'Queen of Cups',
      'name_zh': '圣杯王后',
      'number': 13,
      'suit': 'cups',
      'arcana': 'minor',
      'element': 'water',
      'upright_keywords': ['温柔', '直觉'],
      'reversed_keywords': ['情绪化', '脆弱'],
      'image_key': 'minor_cups_13',
    },
    {
      'id': 38,
      'name': 'Two of Cups',
      'name_zh': '圣杯二',
      'number': 2,
      'suit': 'cups',
      'arcana': 'minor',
      'element': 'water',
      'upright_keywords': ['连结', '和谐'],
      'reversed_keywords': ['失衡', '误解'],
      'image_key': 'minor_cups_02',
    },
    {
      'id': 43,
      'name': 'Seven of Cups',
      'name_zh': '圣杯七',
      'number': 7,
      'suit': 'cups',
      'arcana': 'minor',
      'element': 'water',
      'upright_keywords': ['幻想', '选择'],
      'reversed_keywords': ['清醒', '决断'],
      'image_key': 'minor_cups_07',
    },
    // Swords
    {
      'id': 50,
      'name': 'Ace of Swords',
      'name_zh': '宝剑一',
      'number': 1,
      'suit': 'swords',
      'arcana': 'minor',
      'element': 'air',
      'upright_keywords': ['真相', '清晰'],
      'reversed_keywords': ['混乱', '误判'],
      'image_key': 'minor_swords_01',
    },
    {
      'id': 55,
      'name': 'Six of Swords',
      'name_zh': '宝剑六',
      'number': 6,
      'suit': 'swords',
      'arcana': 'minor',
      'element': 'air',
      'upright_keywords': ['过渡', '前进'],
      'reversed_keywords': ['停滞', '抗拒'],
      'image_key': 'minor_swords_06',
    },
    // Pentacles
    {
      'id': 63,
      'name': 'Ten of Pentacles',
      'name_zh': '星币十',
      'number': 10,
      'suit': 'pentacles',
      'arcana': 'minor',
      'element': 'earth',
      'upright_keywords': ['富足', '传承'],
      'reversed_keywords': ['损失', '孤立'],
      'image_key': 'minor_pentacles_10',
    },
    {
      'id': 70,
      'name': 'Knight of Pentacles',
      'name_zh': '星币骑士',
      'number': 12,
      'suit': 'pentacles',
      'arcana': 'minor',
      'element': 'earth',
      'upright_keywords': ['勤勉', '务实'],
      'reversed_keywords': ['懒惰', '停滞'],
      'image_key': 'minor_pentacles_12',
    },
  ];

  static const Map<String, int> _spreadCardCounts = {
    'single': 1,
    'three_card': 3,
    'love_spread': 5,
    'celtic_cross': 10,
  };

  static const Map<String, List<String>> _spreadPositionLabels = {
    'single': ['启示'],
    'three_card': ['过去', '现在', '未来'],
    'love_spread': ['自己', '对方', '关系', '挑战', '建议'],
    'celtic_cross': [
      '现状',
      '挑战',
      '意识',
      '潜意识',
      '过去',
      '近未来',
      '自我',
      '环境',
      '希望与恐惧',
      '结果',
    ],
  };
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final method = options.method.toUpperCase();

    final mockData = _route(method, path, options.data);
    if (mockData != null) {
      handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: mockData),
      );
      return;
    }

    // Fallback: return empty success for unmatched routes
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic>? _route(String method, String path, dynamic body) {
    // --- Auth ---
    if (path == '/api/auth/login' && method == 'POST') return _authResponse();
    if (path == '/api/auth/register' && method == 'POST') {
      return _authResponse();
    }
    if (path == '/api/auth/refresh' && method == 'POST') return _authResponse();
    if (path == '/api/auth/logout' && method == 'POST') return {};
    if (path == '/api/auth/ws-ticket' && method == 'POST') {
      return {'ticket': 'mock-ticket-${DateTime.now().millisecondsSinceEpoch}'};
    }

    // --- Scenarios ---
    if (path == '/api/scenarios/categories' && method == 'GET') {
      return _scenarioCategories();
    }
    if (path == '/api/scenarios/hot' && method == 'GET') {
      return _scenarioHot();
    }
    if (_matchPath(path, '/api/scenarios/{id}') && method == 'GET') {
      return _scenarioDetail(path.split('/').last);
    }
    if (path == '/api/scenarios' && method == 'GET') {
      return _scenarioList();
    }

    // --- Conversations / Chat REST ---
    if (_matchPath(path, '/api/conversations/{id}/messages') &&
        method == 'GET') {
      return _conversationMessages();
    }
    if (_matchPath(path, '/api/conversations/{id}') && method == 'GET') {
      return _conversationDetail(path.split('/').last);
    }
    if (path == '/api/conversations' && method == 'GET') {
      return _conversationList();
    }

    // --- Mood ---
    if (path == '/api/mood/stats' && method == 'GET') return _moodStats();
    if (path == '/api/mood/insights' && method == 'GET') return _moodInsights();
    if (path == '/api/mood' && method == 'POST') return _moodCreate(body);
    if (path == '/api/mood' && method == 'GET') return _moodList();
    if (_matchPath(path, '/api/mood/{id}') && method == 'DELETE') {
      return {'data': {}};
    }

    // --- Transits ---
    if (path == '/api/transits/active' && method == 'GET') {
      return _transitsActive();
    }
    if (path == '/api/transits/upcoming' && method == 'GET') {
      return _transitsUpcoming();
    }
    if (_matchPath(path, '/api/transits/{id}/dismiss') && method == 'POST') {
      return {'data': {}};
    }
    if (_matchPath(path, '/api/transits/{id}') && method == 'GET') {
      return _transitDetail();
    }
    if (path == '/api/calendar' && method == 'GET') return _calendarEvents();

    // --- Tarot ---
    if (path == '/api/tarot/sessions' && method == 'POST') {
      return _tarotCreate(body);
    }
    if (path == '/api/tarot/sessions' && method == 'GET') {
      return _tarotList();
    }
    if (_matchPath(path, '/api/tarot/sessions/{id}') && method == 'GET') {
      return _tarotDetail(path.split('/').last);
    }
    if (_matchPath(path, '/api/tarot/sessions/{id}') && method == 'PATCH') {
      return _tarotUpdate(path.split('/').last, body);
    }

    // --- Rune ---
    if (path == '/api/rune/sessions' && method == 'POST') {
      return _runeCreate(body);
    }
    if (path == '/api/rune/sessions' && method == 'GET') {
      return _runeList();
    }
    if (_matchPath(path, '/api/rune/sessions/{id}') && method == 'GET') {
      return _runeDetail(path.split('/').last);
    }
    if (_matchPath(path, '/api/rune/sessions/{id}') && method == 'PATCH') {
      return _runeUpdate(path.split('/').last, body);
    }

    // --- Lenormand ---
    if (path == '/api/lenormand/sessions' && method == 'POST') {
      return _lenormandCreate(body);
    }
    if (path == '/api/lenormand/sessions' && method == 'GET') {
      return _lenormandList();
    }
    if (_matchPath(path, '/api/lenormand/sessions/{id}') && method == 'GET') {
      return _lenormandDetail(path.split('/').last);
    }
    if (_matchPath(path, '/api/lenormand/sessions/{id}') && method == 'PATCH') {
      return _lenormandUpdate(path.split('/').last, body);
    }

    // --- I Ching ---
    if (path == '/api/iching/sessions' && method == 'POST') {
      return _ichingCreate(body);
    }
    if (path == '/api/iching/sessions' && method == 'GET') {
      return _ichingList();
    }
    if (_matchPath(path, '/api/iching/sessions/{id}') && method == 'GET') {
      return _ichingDetail(path.split('/').last);
    }
    if (_matchPath(path, '/api/iching/sessions/{id}') && method == 'PATCH') {
      return _ichingUpdate(path.split('/').last, body);
    }

    // --- Friends ---
    if (path == '/api/friends' && method == 'POST') return _friendCreate(body);
    if (path == '/api/friends' && method == 'GET') return _friendList();
    if (_matchPath(path, '/api/friends/{id}') && method == 'GET') {
      return _friendDetail();
    }
    if (_matchPath(path, '/api/friends/{id}') && method == 'PATCH') {
      return _friendDetail();
    }
    if (_matchPath(path, '/api/friends/{id}') && method == 'DELETE') {
      return {'data': {}};
    }

    // --- Share Cards ---
    if (path == '/api/share/cards' && method == 'POST') {
      return _shareCreate(body);
    }
    if (path == '/api/share/cards' && method == 'GET') return _shareList();
    if (_matchPath(path, '/api/share/cards/{token}') && method == 'GET') {
      return _shareDetail();
    }

    // --- Fortune ---
    if (path == '/api/fortune/daily' && method == 'GET') {
      return _dailyFortune();
    }

    // --- Astrology ---
    if (path == '/api/astrology/moon-phase' && method == 'GET') {
      return _moonPhase();
    }

    // --- Profile ---
    if (path == '/api/users/me/profile' && method == 'GET') {
      return _profile();
    }
    if (path == '/api/users/me/profile/core' && method == 'PUT') {
      return _profileUpsertCore(body);
    }

    // --- Location ---
    if (path == '/api/locations/resolve' && method == 'GET') {
      return _locationResolve();
    }

    return null;
  }

  /// Simple path template matcher: `/api/foo/{id}` matches `/api/foo/123`.
  bool _matchPath(String actual, String template) {
    final aParts = actual.split('/');
    final tParts = template.split('/');
    if (aParts.length != tParts.length) return false;
    for (var i = 0; i < tParts.length; i++) {
      if (tParts[i].startsWith('{') && tParts[i].endsWith('}')) continue;
      if (aParts[i] != tParts[i]) return false;
    }
    return true;
  }

  // ============================================================
  // Auth
  // ============================================================

  Map<String, dynamic> _authResponse() => {
    'access_token': 'mock-access-token',
    'refresh_token': 'mock-refresh-token',
    'token_type': 'Bearer',
    'expires_in': 86400,
    'user': {
      'id': 'mock-user-001',
      'email': 'demo@xingjian.app',
      'username': '星辰旅人',
      'email_verified': true,
      'role': 'user',
      'is_admin': false,
    },
  };

  // ============================================================
  // Scenarios
  // ============================================================

  Map<String, dynamic> _scenarioCategories() => {
    'items': [
      {
        'id': 'love',
        'name': '感情运势',
        'slug': 'love',
        'icon': 'heart',
        'display_order': 1,
      },
      {
        'id': 'career',
        'name': '事业发展',
        'slug': 'career',
        'icon': 'briefcase',
        'display_order': 2,
      },
      {
        'id': 'wealth',
        'name': '财富运程',
        'slug': 'wealth',
        'icon': 'coins',
        'display_order': 3,
      },
      {
        'id': 'health',
        'name': '健康养生',
        'slug': 'health',
        'icon': 'heart_pulse',
        'display_order': 4,
      },
      {
        'id': 'personal',
        'name': '个人成长',
        'slug': 'personal',
        'icon': 'sparkles',
        'display_order': 5,
      },
    ],
  };

  Map<String, dynamic> _scenarioHot() => {
    'items': _mockScenarios().sublist(0, 3),
  };

  Map<String, dynamic> _scenarioList() => {
    'items': _mockScenarios(),
    'next_cursor': null,
  };

  Map<String, dynamic> _scenarioDetail(String id) => {
    'id': id,
    'slug': 'weekly-love-reading',
    'title': '本周感情运势深度解读',
    'description': '结合你的星盘，为你详细分析本周的感情走向、桃花运势和人际关系变化。',
    'icon_url': '',
    'category': {
      'id': 'love',
      'slug': 'love',
      'name': '感情运势',
      'icon': 'heart',
      'display_order': 1,
    },
    'tool_bindings': <String>[],
    'preset_questions': ['本周桃花运如何？', '我和TA有缘分吗？'],
    'display_order': 1,
  };

  List<Map<String, dynamic>> _mockScenarios() => [
    {
      'id': 'mock-scenario-001',
      'slug': 'weekly-love',
      'title': '本周感情运势',
      'description': '深入解读你本周的感情走向和桃花运。',
      'icon_url': '',
      'category': {
        'id': 'love',
        'slug': 'love',
        'name': '感情运势',
        'icon': 'heart',
        'display_order': 1,
      },
      'display_order': 1,
    },
    {
      'id': 'mock-scenario-002',
      'slug': 'career-guide',
      'title': '职场贵人指引',
      'description': '分析你近期的事业运和贵人方位。',
      'icon_url': '',
      'category': {
        'id': 'career',
        'slug': 'career',
        'name': '事业发展',
        'icon': 'briefcase',
        'display_order': 2,
      },
      'display_order': 2,
    },
    {
      'id': 'mock-scenario-003',
      'slug': 'monthly-wealth',
      'title': '本月财运预测',
      'description': '详解你本月的正财和偏财运势。',
      'icon_url': '',
      'category': {
        'id': 'wealth',
        'slug': 'wealth',
        'name': '财富运程',
        'icon': 'coins',
        'display_order': 3,
      },
      'display_order': 3,
    },
    {
      'id': 'mock-scenario-004',
      'slug': 'mercury-retrograde',
      'title': '水逆生存指南',
      'description': '水逆期间如何化解不利影响，把握转机。',
      'icon_url': '',
      'category': {
        'id': 'personal',
        'slug': 'personal',
        'name': '个人成长',
        'icon': 'sparkles',
        'display_order': 5,
      },
      'display_order': 4,
    },
    {
      'id': 'mock-scenario-005',
      'slug': 'energy-tuning',
      'title': '身心能量调频',
      'description': '根据星象找到适合你的养生节奏。',
      'icon_url': '',
      'category': {
        'id': 'health',
        'slug': 'health',
        'name': '健康养生',
        'icon': 'heart_pulse',
        'display_order': 4,
      },
      'display_order': 5,
    },
    {
      'id': 'mock-scenario-006',
      'slug': 'new-moon-wish',
      'title': '新月许愿仪式',
      'description': '借助新月能量，设定你的心愿和目标。',
      'icon_url': '',
      'category': {
        'id': 'personal',
        'slug': 'personal',
        'name': '个人成长',
        'icon': 'sparkles',
        'display_order': 5,
      },
      'display_order': 6,
    },
  ];

  // ============================================================
  // Conversations / Chat REST
  // ============================================================

  Map<String, dynamic> _conversationList() => {
    'conversations': [
      {
        'id': 'mock-conv-001',
        'title': '本周运势解读',
        'last_message': '你的金星正在经过第七宫...',
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'updated_at': DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
      },
      {
        'id': 'mock-conv-002',
        'title': '塔罗牌阵解读',
        'last_message': '圣杯王后暗示着情感上的成熟...',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'updated_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      },
      {
        'id': 'mock-conv-003',
        'title': '职场发展建议',
        'last_message': '土星与你的中天形成了有力的三分相...',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        'updated_at': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      },
    ],
    'next_cursor': null,
  };

  Map<String, dynamic> _conversationDetail(String id) => {
    'id': id,
    'title': '本周运势解读',
    'created_at': DateTime.now()
        .subtract(const Duration(hours: 2))
        .toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> _conversationMessages() => {
    'messages': [
      {
        'id': 'mock-msg-001',
        'role': 'user',
        'content': '帮我看看这周的运势怎么样？',
        'blocks': <Map<String, dynamic>>[],
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      },
      {
        'id': 'mock-msg-002',
        'role': 'assistant',
        'content': '',
        'blocks': [
          {
            'id': 'mock-block-001',
            'idx': 0,
            'kind': 'text',
            'status': 'success',
            'content_text':
                '亲爱的星辰旅人，让我为你解读本周的星象能量。\n\n'
                '本周太阳与木星形成和谐的三分相，这是一个充满机遇和正能量的星象配置。'
                '你可能会在社交场合遇到志同道合的朋友，或者在工作中获得上级的认可。\n\n'
                '不过要注意水星与冥王星的四分相，可能会带来一些沟通上的挑战。'
                '建议你在重要对话前多思考，避免冲动表达。',
          },
        ],
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 1, minutes: 58))
            .toIso8601String(),
      },
    ],
    'next_cursor': null,
  };

  // ============================================================
  // Mood
  // ============================================================

  Map<String, dynamic> _moodCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    return {
      'data': {
        'id': 'mock-mood-${DateTime.now().millisecondsSinceEpoch}',
        'score': b['score'] ?? 7,
        'tags': b['tags'] ?? ['平静', '期待'],
        'note': b['note'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _moodList() => {
    'data': {
      'entries': [
        {
          'id': 'mock-mood-001',
          'score': 8,
          'tags': ['开心', '充实'],
          'note': '今天工作顺利，心情不错',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 0))
              .toIso8601String(),
        },
        {
          'id': 'mock-mood-002',
          'score': 6,
          'tags': ['平静', '思考'],
          'note': '水逆期间保持平常心',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        },
        {
          'id': 'mock-mood-003',
          'score': 9,
          'tags': ['兴奋', '期待'],
          'note': '新月许愿，感觉充满希望',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
        },
      ],
    },
  };

  Map<String, dynamic> _moodStats() => {
    'data': {
      'avg_score': 7.5,
      'total_entries': 15,
      'streak_days': 5,
      'score_distribution': {'1-3': 1, '4-6': 4, '7-9': 8, '10': 2},
      'top_tags': [
        {'tag': '平静', 'count': 8},
        {'tag': '开心', 'count': 6},
        {'tag': '期待', 'count': 5},
        {'tag': '思考', 'count': 4},
      ],
    },
  };

  Map<String, dynamic> _moodInsights() => {
    'data': {
      'insights': [
        {
          'type': 'trend',
          'title': '情绪趋势',
          'description':
              '过去一周你的情绪整体呈上升趋势，'
              '尤其是在新月前后情绪最为高涨。',
        },
        {
          'type': 'astro_correlation',
          'title': '星象关联',
          'description':
              '金星进入你的第五宫期间，你的快乐指数明显提升。'
              '建议在这段时间多安排社交和创意活动。',
        },
        {
          'type': 'suggestion',
          'title': '养心建议',
          'description':
              '本周水星逆行，可能会感到沟通不畅。'
              '建议多做冥想和深呼吸练习，保持内心平静。',
        },
      ],
    },
  };

  // ============================================================
  // Transits
  // ============================================================

  Map<String, dynamic> _transitsActive() => {
    'data': {
      'transits': [
        {
          'id': 'mock-transit-001',
          'planet': 'Venus',
          'sign': 'Pisces',
          'house': 7,
          'aspect': 'trine',
          'aspect_planet': 'Jupiter',
          'title': '金星三分木星',
          'summary': '感情运势极佳的时期，有利于表白和深化关系。',
          'start_date': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'end_date': DateTime.now()
              .add(const Duration(days: 5))
              .toIso8601String(),
          'intensity': 0.85,
        },
        {
          'id': 'mock-transit-002',
          'planet': 'Mercury',
          'sign': 'Aquarius',
          'house': 3,
          'aspect': 'square',
          'aspect_planet': 'Pluto',
          'title': '水星四分冥王星',
          'summary': '沟通容易产生误解，避免重要谈判。',
          'start_date': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'end_date': DateTime.now()
              .add(const Duration(days: 3))
              .toIso8601String(),
          'intensity': 0.65,
        },
      ],
    },
  };

  Map<String, dynamic> _transitsUpcoming() => {
    'data': {
      'transits': [
        {
          'id': 'mock-transit-003',
          'planet': 'Mars',
          'sign': 'Aries',
          'house': 1,
          'aspect': 'conjunction',
          'aspect_planet': 'Sun',
          'title': '火星合日',
          'summary': '充满行动力和决断力，适合启动新项目。',
          'start_date': DateTime.now()
              .add(const Duration(days: 7))
              .toIso8601String(),
          'end_date': DateTime.now()
              .add(const Duration(days: 14))
              .toIso8601String(),
          'intensity': 0.90,
        },
      ],
    },
  };

  Map<String, dynamic> _transitDetail() => {
    'data': {
      'id': 'mock-transit-001',
      'planet': 'Venus',
      'sign': 'Pisces',
      'house': 7,
      'aspect': 'trine',
      'aspect_planet': 'Jupiter',
      'title': '金星三分木星',
      'summary': '感情运势极佳的时期，有利于表白和深化关系。',
      'description':
          '当金星在双鱼座与木星形成三分相时，这是最浪漫的星象之一。'
          '你的魅力指数飙升，人际关系中充满温暖和善意。\n\n'
          '对单身者：可能通过艺术、音乐或灵性活动遇到心仪对象。\n'
          '对恋爱中的人：感情进一步升温，适合表达爱意和规划未来。',
      'start_date': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
      'end_date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'intensity': 0.85,
    },
  };

  Map<String, dynamic> _calendarEvents() => {
    'data': {
      'events': [
        {
          'date': DateTime.now().toIso8601String().split('T').first,
          'events': [
            {'type': 'transit', 'title': '金星三分木星', 'importance': 'high'},
            {'type': 'moon', 'title': '上弦月', 'importance': 'medium'},
          ],
        },
        {
          'date': DateTime.now()
              .add(const Duration(days: 7))
              .toIso8601String()
              .split('T')
              .first,
          'events': [
            {'type': 'transit', 'title': '火星合日', 'importance': 'high'},
          ],
        },
        {
          'date': DateTime.now()
              .add(const Duration(days: 14))
              .toIso8601String()
              .split('T')
              .first,
          'events': [
            {'type': 'moon', 'title': '满月 — 双鱼座', 'importance': 'high'},
          ],
        },
      ],
    },
  };

  // ============================================================
  // Tarot — stateful session tracking
  // ============================================================

  Map<String, dynamic> _tarotCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final now = DateTime.now().toIso8601String();
    final id = 'mock-tarot-${DateTime.now().millisecondsSinceEpoch}';
    final spreadType = (b['spread_type'] as String?) ?? 'three_card';
    final cardCount = _spreadCardCounts[spreadType] ?? 3;
    final labels = _spreadPositionLabels[spreadType] ?? ['过去', '现在', '未来'];

    final session = <String, dynamic>{
      'id': id,
      'conversation_id': b['conversation_id'] ?? 'mock-conv-001',
      'spread_type': spreadType,
      'card_count': cardCount,
      'question': b['question'] ?? '',
      'ritual_state': 'shuffling',
      'selected_positions': <int>[],
      'selected_cards': <Map<String, dynamic>>[],
      'position_labels': labels,
      'started_at': now,
      'created_at': now,
    };

    _tarotSessions[id] = session;
    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _tarotDetail(String sessionId) {
    final session = _tarotSessions[sessionId];
    if (session != null) {
      return {'data': Map<String, dynamic>.from(session)};
    }

    // Fallback for unknown IDs (e.g. history entries) — completed session
    final now = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String();
    return {
      'data': {
        'id': sessionId,
        'conversation_id': 'mock-conv-002',
        'spread_type': 'three_card',
        'card_count': 3,
        'question': '我的感情何去何从？',
        'ritual_state': 'completed',
        'selected_positions': [0, 1, 2],
        'selected_cards': [
          {
            'position': 0,
            'position_label': '过去',
            'card': {
              'id': 36,
              'name': 'Queen of Cups',
              'name_zh': '圣杯王后',
              'number': 13,
              'suit': 'cups',
              'arcana': 'minor',
              'element': 'water',
              'orientation': 'upright',
              'upright_keywords': ['温柔', '直觉'],
              'reversed_keywords': ['情绪化', '脆弱'],
              'image_key': 'minor_cups_13',
            },
          },
          {
            'position': 1,
            'position_label': '现在',
            'card': {
              'id': 6,
              'name': 'The Lovers',
              'name_zh': '恋人',
              'number': 6,
              'suit': '',
              'arcana': 'major',
              'element': 'air',
              'orientation': 'upright',
              'upright_keywords': ['爱情', '和谐'],
              'reversed_keywords': ['失衡', '分离'],
              'image_key': 'major_06_lovers',
            },
          },
          {
            'position': 2,
            'position_label': '未来',
            'card': {
              'id': 63,
              'name': 'Ten of Pentacles',
              'name_zh': '星币十',
              'number': 10,
              'suit': 'pentacles',
              'arcana': 'minor',
              'element': 'earth',
              'orientation': 'reversed',
              'upright_keywords': ['富足', '传承'],
              'reversed_keywords': ['损失', '孤立'],
              'image_key': 'minor_pentacles_10',
            },
          },
        ],
        'position_labels': ['过去', '现在', '未来'],
        'started_at': now,
        'completed_at': now,
      },
    };
  }

  Map<String, dynamic> _tarotUpdate(String sessionId, dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final session = _tarotSessions[sessionId];

    if (session == null) {
      // Unknown session — echo back what was sent
      return {
        'data': {
          'id': sessionId,
          'ritual_state': b['ritual_state'] ?? 'completed',
          'selected_positions': b['selected_positions'] ?? <int>[],
          'selected_cards': b['selected_cards'] ?? <Map<String, dynamic>>[],
        },
      };
    }

    // Apply state mutation
    if (b['ritual_state'] != null) {
      session['ritual_state'] = b['ritual_state'];
    }
    if (b['selected_positions'] != null) {
      session['selected_positions'] = b['selected_positions'];
    }

    // When transitioning to revealing with positions, generate resolved cards
    if (b['ritual_state'] == 'revealing' && b['selected_positions'] != null) {
      final positions = (b['selected_positions'] as List<dynamic>).cast<int>();
      final labels = (session['position_labels'] as List<dynamic>)
          .cast<String>();
      final shuffled = List<Map<String, dynamic>>.from(
        _mockCardPool.map((c) => Map<String, dynamic>.from(c)),
      )..shuffle();

      final cards = <Map<String, dynamic>>[];
      for (var i = 0; i < positions.length && i < shuffled.length; i++) {
        final cardData = shuffled[i];
        cardData['orientation'] = (i % 3 == 0) ? 'reversed' : 'upright';
        cards.add({
          'position': positions[i],
          'position_label': i < labels.length
              ? labels[i]
              : '位置${positions[i] + 1}',
          'card': cardData,
        });
      }
      session['selected_cards'] = cards;
    }

    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _tarotList() {
    final sessions = _tarotSessions.values
        .map(
          (s) => <String, dynamic>{
            'id': s['id'],
            'spread_type': s['spread_type'],
            'question': s['question'],
            'ritual_state': s['ritual_state'],
            'created_at': s['created_at'],
          },
        )
        .toList();

    // Always include a history entry
    if (sessions.every((s) => s['id'] != 'mock-tarot-001')) {
      sessions.add({
        'id': 'mock-tarot-001',
        'spread_type': 'celtic_cross',
        'question': '我的感情何去何从？',
        'ritual_state': 'completed',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      });
    }

    return {
      'data': {'sessions': sessions},
    };
  }

  // ============================================================
  // Friends
  // ============================================================

  Map<String, dynamic> _friendCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    return {
      'data': {
        'id': 'mock-friend-${DateTime.now().millisecondsSinceEpoch}',
        'name': b['name'] ?? '好友',
        'birth_date': b['birth_date'] ?? '1995-06-15',
        'birth_time': b['birth_time'],
        'latitude': b['latitude'] ?? 39.9042,
        'longitude': b['longitude'] ?? 116.4074,
        'timezone': b['timezone'] ?? 'Asia/Shanghai',
        'birth_location_name': b['birth_location_name'] ?? '北京',
        'relationship_label': b['relationship_label'] ?? '朋友',
        'created_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _friendList() => {
    'data': {
      'friends': [
        {
          'id': 'mock-friend-001',
          'name': '小月',
          'birth_date': '1996-03-21',
          'birth_time': '14:30',
          'latitude': 31.2304,
          'longitude': 121.4737,
          'timezone': 'Asia/Shanghai',
          'birth_location_name': '上海',
          'relationship_label': '闺蜜',
          'sun_sign': 'Aries',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
        },
        {
          'id': 'mock-friend-002',
          'name': '星辰',
          'birth_date': '1994-08-08',
          'birth_time': '09:15',
          'latitude': 39.9042,
          'longitude': 116.4074,
          'timezone': 'Asia/Shanghai',
          'birth_location_name': '北京',
          'relationship_label': '男朋友',
          'sun_sign': 'Leo',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 60))
              .toIso8601String(),
        },
      ],
    },
  };

  Map<String, dynamic> _friendDetail() => {
    'data': {
      'id': 'mock-friend-001',
      'name': '小月',
      'birth_date': '1996-03-21',
      'birth_time': '14:30',
      'latitude': 31.2304,
      'longitude': 121.4737,
      'timezone': 'Asia/Shanghai',
      'birth_location_name': '上海',
      'relationship_label': '闺蜜',
      'sun_sign': 'Aries',
      'moon_sign': 'Cancer',
      'rising_sign': 'Libra',
      'created_at': DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
    },
  };

  // ============================================================
  // Share Cards
  // ============================================================

  Map<String, dynamic> _shareCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    return {
      'data': {
        'id': 'mock-card-${DateTime.now().millisecondsSinceEpoch}',
        'card_type': b['card_type'] ?? 'daily_horoscope',
        'share_token': 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
        'source_data': b['source_data'] ?? {},
        'created_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _shareList() => {
    'data': {
      'cards': [
        {
          'id': 'mock-card-001',
          'card_type': 'daily_horoscope',
          'share_token': 'mock-token-001',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        },
      ],
    },
  };

  Map<String, dynamic> _shareDetail() => {
    'data': {
      'id': 'mock-card-001',
      'card_type': 'daily_horoscope',
      'share_token': 'mock-token-001',
      'source_data': {
        'sign': '双鱼座',
        'date': DateTime.now().toIso8601String().split('T').first,
        'score': 88,
        'summary': '今日桃花运旺盛，适合社交和表达感情。',
      },
      'created_at': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    },
  };

  // ============================================================
  // Astrology
  // ============================================================

  // ============================================================
  // Daily Fortune
  // ============================================================

  static const _fortuneSets = [
    {
      'title': '火花闪现 行动为先',
      'advice': '主动出击，把握机遇',
      'avoid': '犹豫不决，错失良机',
      'overall_score': 86,
      'dimensions': [
        {'key': 'love', 'label': '恋爱', 'score': 91},
        {'key': 'career', 'label': '事业', 'score': 47},
        {'key': 'wealth', 'label': '财富', 'score': 40},
        {'key': 'study', 'label': '学业', 'score': 96},
      ],
      'lucky_elements': {
        'color': '紫色',
        'number': 7,
        'flower': '薰衣草',
        'stone': '紫水晶',
      },
    },
    {
      'title': '静水流深 以柔克刚',
      'advice': '沉淀自我，厚积薄发',
      'avoid': '急功近利，操之过急',
      'overall_score': 72,
      'dimensions': [
        {'key': 'love', 'label': '恋爱', 'score': 65},
        {'key': 'career', 'label': '事业', 'score': 78},
        {'key': 'wealth', 'label': '财富', 'score': 82},
        {'key': 'study', 'label': '学业', 'score': 60},
      ],
      'lucky_elements': {
        'color': '深蓝',
        'number': 3,
        'flower': '莲花',
        'stone': '月光石',
      },
    },
    {
      'title': '星光指路 真心可鉴',
      'advice': '坦诚沟通，化解误会',
      'avoid': '隐瞒心事，独自承担',
      'overall_score': 93,
      'dimensions': [
        {'key': 'love', 'label': '恋爱', 'score': 95},
        {'key': 'career', 'label': '事业', 'score': 88},
        {'key': 'wealth', 'label': '财富', 'score': 75},
        {'key': 'study', 'label': '学业', 'score': 91},
      ],
      'lucky_elements': {
        'color': '金色',
        'number': 9,
        'flower': '向日葵',
        'stone': '黄水晶',
      },
    },
  ];

  Map<String, dynamic> _dailyFortune() {
    final now = DateTime.now();
    final idx = now.day % _fortuneSets.length;
    final set = _fortuneSets[idx];
    return {
      'data': {
        'date':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'moon_phase': 'waxing_crescent',
        ...set,
      },
    };
  }

  Map<String, dynamic> _moonPhase() => {
    'data': {
      'date': DateTime.now().toIso8601String().split('T').first,
      'phase_name': '上弦月',
      'phase_angle': 90.0,
      'illumination': 0.50,
      'lunar_day': 7,
      'next_full_moon': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String()
          .split('T')
          .first,
      'next_new_moon': DateTime.now()
          .add(const Duration(days: 22))
          .toIso8601String()
          .split('T')
          .first,
      'emoji': '🌓',
    },
  };

  // ============================================================
  // Profile
  // ============================================================

  // Stateful: stores saved birth data so GET returns it after PUT
  Map<String, dynamic>? _savedBirthCore;

  Map<String, dynamic> _profile() {
    return {
      'data': {
        'core':
            _savedBirthCore ??
            {
              'user_id': 'mock-user-001',
              'birth_date': '1990-06-25',
              'birth_time': '12:00',
              'birth_time_accuracy': 'exact',
              'current_birth_place_id': 'mock-place-001',
              'completeness_score': 0.8,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
        'current_birth_place': {
          'id': 'mock-place-001',
          'name': '北京',
          'normalized_name': '北京',
          'formatted_address': '北京市, 中国',
          'latitude': 39.9042,
          'longitude': 116.4074,
          'timezone': 'Asia/Shanghai',
          'country_code': 'CN',
        },
        'birth_places': <Map<String, dynamic>>[],
        'values': <Map<String, dynamic>>[],
      },
    };
  }

  Map<String, dynamic> _profileUpsertCore(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final core = {
      'user_id': 'mock-user-001',
      'birth_date': b['birth_date'],
      'birth_time': b['birth_time'],
      'birth_time_accuracy': b['birth_time_accuracy'] ?? 'unknown',
      'current_birth_place_id': 'mock-place-001',
      'completeness_score': 0.8,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    // Persist so subsequent GET /user-profile returns saved data
    _savedBirthCore = core;
    return {
      'data': {'core': core},
    };
  }

  // ============================================================
  // Location
  // ============================================================

  Map<String, dynamic> _locationResolve() => {
    'data': {
      'query': '',
      'candidates': [
        {
          'name': '北京',
          'formatted_address': '北京市, 中国',
          'latitude': 39.9042,
          'longitude': 116.4074,
          'timezone': 'Asia/Shanghai',
          'country_code': 'CN',
          'admin_area': '北京市',
          'confidence': 0.95,
        },
        {
          'name': '上海',
          'formatted_address': '上海市, 中国',
          'latitude': 31.2304,
          'longitude': 121.4737,
          'timezone': 'Asia/Shanghai',
          'country_code': 'CN',
          'admin_area': '上海市',
          'confidence': 0.92,
        },
        {
          'name': '广州',
          'formatted_address': '广州市, 广东省, 中国',
          'latitude': 23.1291,
          'longitude': 113.2644,
          'timezone': 'Asia/Shanghai',
          'country_code': 'CN',
          'admin_area': '广东省',
          'confidence': 0.90,
        },
      ],
      'provider': 'mock',
    },
  };

  // ============================================================
  // Rune — stateful session tracking
  // ============================================================

  static const _mockRunePool = [
    {
      'id': 1,
      'name': 'Fehu',
      'name_zh': '费胡',
      'symbol': '\u16A0',
      'meaning': 'Wealth, abundance',
      'meaning_zh': '财富、丰盛',
    },
    {
      'id': 2,
      'name': 'Uruz',
      'name_zh': '乌鲁兹',
      'symbol': '\u16A2',
      'meaning': 'Strength, health',
      'meaning_zh': '力量、健康',
    },
    {
      'id': 3,
      'name': 'Thurisaz',
      'name_zh': '索里萨兹',
      'symbol': '\u16A6',
      'meaning': 'Protection, gateway',
      'meaning_zh': '保护、门户',
    },
    {
      'id': 4,
      'name': 'Ansuz',
      'name_zh': '安苏兹',
      'symbol': '\u16A8',
      'meaning': 'Wisdom, communication',
      'meaning_zh': '智慧、沟通',
    },
    {
      'id': 5,
      'name': 'Raidho',
      'name_zh': '莱多',
      'symbol': '\u16B1',
      'meaning': 'Journey, movement',
      'meaning_zh': '旅途、移动',
    },
  ];

  static const Map<String, int> _runeSpreadCounts = {
    'single': 1,
    'three_rune': 3,
    'five_rune_cross': 5,
  };

  static const Map<String, List<String>> _runePositionLabels = {
    'single': ['启示'],
    'three_rune': ['过去', '现在', '未来'],
    'five_rune_cross': ['中心', '过去', '未来', '基础', '结果'],
  };

  Map<String, dynamic> _runeCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final now = DateTime.now().toIso8601String();
    final id = 'mock-rune-${DateTime.now().millisecondsSinceEpoch}';
    final spreadType = (b['spread_type'] as String?) ?? 'three_rune';
    final runeCount = _runeSpreadCounts[spreadType] ?? 3;
    final labels = _runePositionLabels[spreadType] ?? ['过去', '现在', '未来'];

    final session = <String, dynamic>{
      'id': id,
      'conversation_id': b['conversation_id'] ?? 'mock-conv-001',
      'spread_type': spreadType,
      'rune_count': runeCount,
      'question': b['question'] ?? '',
      'ritual_state': 'drawing',
      'drawn_runes': <Map<String, dynamic>>[],
      'position_labels': labels,
      'started_at': now,
    };

    _runeSessions[id] = session;
    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _runeDetail(String sessionId) {
    final session = _runeSessions[sessionId];
    if (session != null) {
      return {'data': Map<String, dynamic>.from(session)};
    }
    return {
      'data': {
        'id': sessionId,
        'conversation_id': 'mock-conv-001',
        'spread_type': 'three_rune',
        'rune_count': 3,
        'question': '',
        'ritual_state': 'drawing',
        'drawn_runes': <Map<String, dynamic>>[],
        'position_labels': ['过去', '现在', '未来'],
        'started_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _runeUpdate(String sessionId, dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final session = _runeSessions[sessionId];

    if (session == null) {
      return {
        'data': {
          'id': sessionId,
          'ritual_state': b['ritual_state'] ?? 'completed',
        },
      };
    }

    if (b['ritual_state'] != null) {
      session['ritual_state'] = b['ritual_state'];
    }

    // Generate drawn runes when transitioning to revealing
    if (b['ritual_state'] == 'revealing') {
      final runeCount = session['rune_count'] as int? ?? 3;
      final shuffled = List<Map<String, dynamic>>.from(
        _mockRunePool.map((r) => Map<String, dynamic>.from(r)),
      )..shuffle();
      session['drawn_runes'] = shuffled.take(runeCount).toList();
    }

    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _runeList() {
    return {
      'data': {
        'sessions': _runeSessions.values
            .map(
              (s) => <String, dynamic>{
                'id': s['id'],
                'spread_type': s['spread_type'],
                'ritual_state': s['ritual_state'],
              },
            )
            .toList(),
      },
    };
  }

  // ============================================================
  // Lenormand — stateful session tracking
  // ============================================================

  static const _mockLenormandPool = [
    {
      'id': 1,
      'number': 1,
      'name': 'Rider',
      'name_zh': '骑士',
      'icon': '\uD83C\uDFC7',
      'keywords': ['news', 'speed'],
      'keywords_zh': ['消息', '速度'],
    },
    {
      'id': 2,
      'number': 2,
      'name': 'Clover',
      'name_zh': '三叶草',
      'icon': '\u2618',
      'keywords': ['luck', 'opportunity'],
      'keywords_zh': ['运气', '机会'],
    },
    {
      'id': 3,
      'number': 3,
      'name': 'Ship',
      'name_zh': '船',
      'icon': '\u26F5',
      'keywords': ['travel', 'distance'],
      'keywords_zh': ['旅行', '远方'],
    },
    {
      'id': 4,
      'number': 4,
      'name': 'House',
      'name_zh': '房屋',
      'icon': '\uD83C\uDFE0',
      'keywords': ['home', 'stability'],
      'keywords_zh': ['家庭', '稳定'],
    },
    {
      'id': 5,
      'number': 5,
      'name': 'Tree',
      'name_zh': '树',
      'icon': '\uD83C\uDF33',
      'keywords': ['health', 'growth'],
      'keywords_zh': ['健康', '成长'],
    },
    {
      'id': 6,
      'number': 6,
      'name': 'Clouds',
      'name_zh': '云',
      'icon': '\u2601',
      'keywords': ['confusion', 'doubt'],
      'keywords_zh': ['困惑', '疑虑'],
    },
    {
      'id': 7,
      'number': 7,
      'name': 'Snake',
      'name_zh': '蛇',
      'icon': '\uD83D\uDC0D',
      'keywords': ['wisdom', 'deception'],
      'keywords_zh': ['智慧', '欺骗'],
    },
    {
      'id': 8,
      'number': 8,
      'name': 'Coffin',
      'name_zh': '棺材',
      'icon': '\u26B0',
      'keywords': ['ending', 'transformation'],
      'keywords_zh': ['结束', '转变'],
    },
    {
      'id': 9,
      'number': 9,
      'name': 'Bouquet',
      'name_zh': '花束',
      'icon': '\uD83D\uDC90',
      'keywords': ['gift', 'beauty'],
      'keywords_zh': ['礼物', '美丽'],
    },
    {
      'id': 10,
      'number': 10,
      'name': 'Scythe',
      'name_zh': '镰刀',
      'icon': '\uD83D\uDDE1',
      'keywords': ['sudden', 'decision'],
      'keywords_zh': ['突然', '决断'],
    },
  ];

  static const Map<String, int> _lenormandSpreadCounts = {
    'single': 1,
    'three_card': 3,
    'five_card': 5,
    'grand_tableau': 36,
  };

  static const Map<String, List<String>> _lenormandPositionLabels = {
    'single': ['启示'],
    'three_card': ['过去', '现在', '未来'],
    'five_card': ['主题', '过去', '现在', '未来', '建议'],
    'grand_tableau': [],
  };

  Map<String, dynamic> _lenormandCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final now = DateTime.now().toIso8601String();
    final id = 'mock-lenormand-${DateTime.now().millisecondsSinceEpoch}';
    final spreadType = (b['spread_type'] as String?) ?? 'three_card';
    final cardCount = _lenormandSpreadCounts[spreadType] ?? 3;
    final labels = _lenormandPositionLabels[spreadType] ?? ['过去', '现在', '未来'];

    final session = <String, dynamic>{
      'id': id,
      'conversation_id': b['conversation_id'] ?? 'mock-conv-001',
      'spread_type': spreadType,
      'card_count': cardCount,
      'question': b['question'] ?? '',
      'ritual_state': 'shuffling',
      'selected_positions': <int>[],
      'selected_cards': <Map<String, dynamic>>[],
      'position_labels': labels,
      'started_at': now,
    };

    _lenormandSessions[id] = session;
    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _lenormandDetail(String sessionId) {
    final session = _lenormandSessions[sessionId];
    if (session != null) {
      return {'data': Map<String, dynamic>.from(session)};
    }
    return {
      'data': {
        'id': sessionId,
        'conversation_id': 'mock-conv-001',
        'spread_type': 'three_card',
        'card_count': 3,
        'question': '',
        'ritual_state': 'shuffling',
        'selected_positions': <int>[],
        'selected_cards': <Map<String, dynamic>>[],
        'position_labels': ['过去', '现在', '未来'],
        'started_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _lenormandUpdate(String sessionId, dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final session = _lenormandSessions[sessionId];

    if (session == null) {
      return {
        'data': {
          'id': sessionId,
          'ritual_state': b['ritual_state'] ?? 'completed',
        },
      };
    }

    if (b['ritual_state'] != null) session['ritual_state'] = b['ritual_state'];
    if (b['selected_positions'] != null)
      session['selected_positions'] = b['selected_positions'];

    // Generate resolved cards when revealing
    if (b['ritual_state'] == 'revealing' && b['selected_positions'] != null) {
      final positions = (b['selected_positions'] as List<dynamic>).cast<int>();
      final labels = (session['position_labels'] as List<dynamic>)
          .cast<String>();
      final shuffled = List<Map<String, dynamic>>.from(
        _mockLenormandPool.map((c) => Map<String, dynamic>.from(c)),
      )..shuffle();

      final cards = <Map<String, dynamic>>[];
      for (var i = 0; i < positions.length && i < shuffled.length; i++) {
        cards.add({
          'position': positions[i],
          'position_label': i < labels.length
              ? labels[i]
              : '位置${positions[i] + 1}',
          'card': shuffled[i],
        });
      }
      session['selected_cards'] = cards;
    }

    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _lenormandList() {
    return {
      'data': {
        'sessions': _lenormandSessions.values
            .map(
              (s) => <String, dynamic>{
                'id': s['id'],
                'spread_type': s['spread_type'],
                'ritual_state': s['ritual_state'],
              },
            )
            .toList(),
      },
    };
  }

  // ============================================================
  // I Ching — stateful session tracking
  // ============================================================

  Map<String, dynamic> _ichingCreate(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final now = DateTime.now().toIso8601String();
    final id = 'mock-iching-${DateTime.now().millisecondsSinceEpoch}';

    final session = <String, dynamic>{
      'id': id,
      'conversation_id': b['conversation_id'] ?? 'mock-conv-001',
      'question': b['question'] ?? '',
      'ritual_state': 'tossing',
      'tosses': <Map<String, dynamic>>[],
      'primary_hexagram': null,
      'transformed_hexagram': null,
      'started_at': now,
    };

    _ichingSessions[id] = session;
    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _ichingDetail(String sessionId) {
    final session = _ichingSessions[sessionId];
    if (session != null) {
      return {'data': Map<String, dynamic>.from(session)};
    }
    return {
      'data': {
        'id': sessionId,
        'conversation_id': 'mock-conv-001',
        'question': '',
        'ritual_state': 'tossing',
        'tosses': <Map<String, dynamic>>[],
        'started_at': DateTime.now().toIso8601String(),
      },
    };
  }

  Map<String, dynamic> _ichingUpdate(String sessionId, dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    final session = _ichingSessions[sessionId];

    if (session == null) {
      return {
        'data': {
          'id': sessionId,
          'ritual_state': b['ritual_state'] ?? 'completed',
        },
      };
    }

    if (b['ritual_state'] != null) session['ritual_state'] = b['ritual_state'];
    if (b['tosses'] != null) session['tosses'] = b['tosses'];

    // Generate hexagrams when revealing
    if (b['ritual_state'] == 'revealing' && b['tosses'] != null) {
      final tosses = (b['tosses'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final lines = <Map<String, dynamic>>[];
      final transformedLines = <Map<String, dynamic>>[];

      for (var i = 0; i < tosses.length && i < 6; i++) {
        final sum = tosses[i]['sum'] as int? ?? 7;
        final isYang = sum.isOdd;
        final isMoving = sum == 6 || sum == 9;

        lines.add({
          'position': i + 1,
          'is_yang': isYang,
          'is_moving': isMoving,
          'text': '',
          'text_zh': '',
        });

        // Transformed: moving lines flip
        transformedLines.add({
          'position': i + 1,
          'is_yang': isMoving ? !isYang : isYang,
          'is_moving': false,
          'text': '',
          'text_zh': '',
        });
      }

      session['primary_hexagram'] = {
        'number': 1,
        'name': 'Qian',
        'name_zh': '乾',
        'symbol': '\u4DC0',
        'lines': lines,
      };

      final hasMoving = tosses.any(
        (t) => (t['sum'] as int?) == 6 || (t['sum'] as int?) == 9,
      );
      if (hasMoving) {
        session['transformed_hexagram'] = {
          'number': 2,
          'name': 'Kun',
          'name_zh': '坤',
          'symbol': '\u4DC1',
          'lines': transformedLines,
        };
      }
    }

    return {'data': Map<String, dynamic>.from(session)};
  }

  Map<String, dynamic> _ichingList() {
    return {
      'data': {
        'sessions': _ichingSessions.values
            .map(
              (s) => <String, dynamic>{
                'id': s['id'],
                'question': s['question'],
                'ritual_state': s['ritual_state'],
              },
            )
            .toList(),
      },
    };
  }
}
