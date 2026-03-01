import 'package:dio/dio.dart';

/// Dio interceptor that returns mock Chinese data for all API routes.
/// Used by [main_mock.dart] to create a self-contained demo build.
class MockInterceptor extends Interceptor {
  /// In-memory tarot session store for stateful ritual flow.
  final Map<String, Map<String, dynamic>> _tarotSessions = {};

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
      'image_key': 'major_00',
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
      'image_key': 'major_01',
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
      'image_key': 'major_02',
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
      'image_key': 'major_06',
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
      'image_key': 'major_10',
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
      'image_key': 'major_17',
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
      'image_key': 'wands_01',
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
      'image_key': 'wands_08',
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
      'image_key': 'cups_13',
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
      'image_key': 'cups_02',
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
      'image_key': 'cups_07',
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
      'image_key': 'swords_01',
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
      'image_key': 'swords_06',
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
      'image_key': 'pentacles_10',
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
      'image_key': 'pentacles_12',
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
      'email': 'demo@yuejian.app',
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
              'image_key': 'cups_13',
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
              'image_key': 'major_06',
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
              'image_key': 'pentacles_10',
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

  Map<String, dynamic> _profile() => {
    'data': {
      'core': {
        'user_id': 'mock-user-001',
        'birth_date': null,
        'birth_time': null,
        'birth_time_accuracy': 'unknown',
        'current_birth_place_id': null,
        'completeness_score': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      'current_birth_place': null,
      'birth_places': <Map<String, dynamic>>[],
      'values': <Map<String, dynamic>>[],
    },
  };

  Map<String, dynamic> _profileUpsertCore(dynamic body) {
    final b = body as Map<String, dynamic>? ?? {};
    return {
      'data': {
        'core': {
          'user_id': 'mock-user-001',
          'birth_date': b['birth_date'],
          'birth_time': b['birth_time'],
          'birth_time_accuracy': b['birth_time_accuracy'] ?? 'unknown',
          'current_birth_place_id': 'mock-place-001',
          'completeness_score': 0.8,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      },
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
}
