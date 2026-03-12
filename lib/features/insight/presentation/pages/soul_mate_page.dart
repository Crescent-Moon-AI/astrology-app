import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/theme/cosmic_colors.dart';
import '../../../../../shared/widgets/starfield_background.dart';
import '../../../settings/presentation/providers/profile_providers.dart';

/// Zodiac sign compatibility data for soul mate analysis.
const _zodiacSigns = [
  '白羊座',
  '金牛座',
  '双子座',
  '巨蟹座',
  '狮子座',
  '处女座',
  '天秤座',
  '天蝎座',
  '射手座',
  '摩羯座',
  '水瓶座',
  '双鱼座',
];

const _zodiacSignsEn = [
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces',
];

const _zodiacEmojis = [
  '♈',
  '♉',
  '♊',
  '♋',
  '♌',
  '♍',
  '♎',
  '♏',
  '♐',
  '♑',
  '♒',
  '♓',
];

// Each sign's top compatible signs (index-based, 0=Aries)
const _compatibility = [
  [7, 8, 4], // Aries → Scorpio, Sagittarius, Leo
  [5, 9, 2], // Taurus → Virgo, Capricorn, Gemini
  [6, 10, 4], // Gemini → Libra, Aquarius, Leo
  [7, 11, 5], // Cancer → Scorpio, Pisces, Virgo
  [0, 8, 2], // Leo → Aries, Sagittarius, Gemini
  [1, 9, 3], // Virgo → Taurus, Capricorn, Cancer
  [2, 10, 0], // Libra → Gemini, Aquarius, Aries
  [3, 0, 9], // Scorpio → Cancer, Aries, Capricorn
  [0, 4, 10], // Sagittarius → Aries, Leo, Aquarius
  [1, 5, 7], // Capricorn → Taurus, Virgo, Scorpio
  [2, 6, 8], // Aquarius → Gemini, Libra, Sagittarius
  [3, 7, 1], // Pisces → Cancer, Scorpio, Taurus
];

// Soul mate personality traits per sign
const _soulMateTraits = [
  ['热情奔放', '勇于冒险', '充满活力'], // Aries
  ['稳重可靠', '艺术品味', '深情专一'], // Taurus
  ['机智聪慧', '风趣幽默', '善于沟通'], // Gemini
  ['温柔体贴', '情感丰富', '忠诚顾家'], // Cancer
  ['自信魅力', '慷慨大方', '充满创造力'], // Leo
  ['细腻体贴', '踏实上进', '善解人意'], // Virgo
  ['优雅迷人', '公平公正', '浪漫感性'], // Libra
  ['深邃神秘', '忠诚专一', '极具洞察力'], // Scorpio
  ['乐观开朗', '追求自由', '智慧博学'], // Sagittarius
  ['踏实勤奋', '责任感强', '成熟稳重'], // Capricorn
  ['独立创新', '博爱人道', '思维前卫'], // Aquarius
  ['浪漫感性', '善解人意', '极富同情心'], // Pisces
];

const _soulMateTraitsEn = [
  ['Passionate', 'Adventurous', 'Energetic'],
  ['Reliable', 'Artistic', 'Devoted'],
  ['Witty', 'Playful', 'Communicative'],
  ['Nurturing', 'Emotional', 'Loyal'],
  ['Confident', 'Generous', 'Creative'],
  ['Thoughtful', 'Grounded', 'Perceptive'],
  ['Charming', 'Fair', 'Romantic'],
  ['Mysterious', 'Devoted', 'Insightful'],
  ['Optimistic', 'Free-spirited', 'Wise'],
  ['Ambitious', 'Responsible', 'Mature'],
  ['Independent', 'Humanitarian', 'Visionary'],
  ['Romantic', 'Empathetic', 'Compassionate'],
];

// Brief soul mate visualization per sign
const _visualization = [
  '你的灵魂伴侣拥有神秘的深邃眼神，他/她既能与你匹敌，又能激发你内心最深处的热情。',
  '你的灵魂伴侣沉稳而迷人，用细水长流的温柔守护你，是一个让你感到无比安全的存在。',
  '你的灵魂伴侣才思敏捷、话语如风，总能以独特视角让你眼前一亮，令你欲罢不能。',
  '你的灵魂伴侣像月光一般温柔，用无尽的包容与理解让你的心灵找到真正的归宿。',
  '你的灵魂伴侣气场十足，自信而不张扬，与你并肩时你们便是全场最耀眼的存在。',
  '你的灵魂伴侣细腻敏锐，总能在你开口之前读懂你的心，是真正懂你的那个人。',
  '你的灵魂伴侣优雅从容、深情似海，与你相处时总能营造出如诗如画的浪漫氛围。',
  '你的灵魂伴侣深邃如夜，神秘而专情，一旦认定你便是全情投入，无可替代。',
  '你的灵魂伴侣阳光开朗、见识广博，与你分享世界每个角落的精彩，带你一起飞翔。',
  '你的灵魂伴侣脚踏实地、意志坚定，以无声的行动证明爱意，是你最可靠的人生伴侣。',
  '你的灵魂伴侣思维前卫、独一无二，他/她理解你的不同寻常，欣赏你的独特个性。',
  '你的灵魂伴侣如诗如梦，以无边的温柔与感性包裹你，让你的灵魂得到最深的慰藉。',
];

/// Compute zodiac sign index (0=Aries) from a birth date string (YYYY-MM-DD).
/// Returns -1 if date is null/unparseable.
int _sunSignIndexFromBirthDate(String? birthDate) {
  if (birthDate == null) return -1;
  final dt = DateTime.tryParse(birthDate);
  if (dt == null) return -1;
  final m = dt.month;
  final d = dt.day;
  if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return 0; // Aries
  if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return 1; // Taurus
  if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return 2; // Gemini
  if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return 3; // Cancer
  if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return 4; // Leo
  if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return 5; // Virgo
  if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return 6; // Libra
  if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return 7; // Scorpio
  if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return 8; // Sagittarius
  if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return 9; // Capricorn
  if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return 10; // Aquarius
  return 11; // Pisces
}

class SoulMatePage extends ConsumerWidget {
  const SoulMatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final profile = ref.watch(userProfileProvider).asData?.value;
    final birthDate = profile?.core.birthDate;
    final signIdx = _sunSignIndexFromBirthDate(birthDate);
    // Default to Scorpio (7) when birth date unknown
    final effectiveIdx = signIdx >= 0 ? signIdx : 7;
    final compatibleIndices = _compatibility[effectiveIdx];
    final traits = isZh
        ? _soulMateTraits[effectiveIdx]
        : _soulMateTraitsEn[effectiveIdx];
    final viz = _visualization[effectiveIdx];
    final userSignName = signIdx >= 0
        ? (isZh ? _zodiacSigns[signIdx] : _zodiacSignsEn[signIdx])
        : null;

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: CosmicColors.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        isZh ? '灵魂伴侣' : 'Soul Mate',
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero card
                      _HeroCard(
                        isZh: isZh,
                        visualization: viz,
                        compatibleIndices: compatibleIndices,
                        userSignName: userSignName,
                      ),
                      const SizedBox(height: 20),

                      // Compatible signs section
                      Text(
                        isZh ? '最契合的星座' : 'Most Compatible Signs',
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: compatibleIndices.asMap().entries.map((e) {
                          final idx = e.value;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: e.key < compatibleIndices.length - 1
                                    ? 10
                                    : 0,
                              ),
                              child: _SignCard(
                                emoji: _zodiacEmojis[idx],
                                name: isZh
                                    ? _zodiacSigns[idx]
                                    : _zodiacSignsEn[idx],
                                rank: e.key + 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Traits section
                      Text(
                        isZh ? '理想伴侣特质' : 'Ideal Partner Traits',
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...traits.map((t) => _TraitRow(trait: t)),
                      const SizedBox(height: 20),

                      // What next section
                      Text(
                        isZh ? '深度探索' : 'Deep Exploration',
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _AnalysisCard(isZh: isZh),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.pushNamed(
                'chat',
                queryParameters: {
                  'prefill_message': isZh
                      ? '根据我的星盘，帮我深度分析我的灵魂伴侣：最适合我的星座特征、我们之间的情感动态、以及如何吸引到我的灵魂伴侣？'
                      : 'Based on my birth chart, deeply analyze my soul mate: what zodiac signs are most compatible, our emotional dynamics, and how to attract my soul mate?',
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CosmicColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                isZh ? '与AI深度探索灵魂伴侣' : 'Explore Soul Mate with AI',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final bool isZh;
  final String visualization;
  final List<int> compatibleIndices;
  final String? userSignName;

  const _HeroCard({
    required this.isZh,
    required this.visualization,
    required this.compatibleIndices,
    this.userSignName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF15161C), Color(0xFF000109)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withAlpha(33), width: 1),
      ),
      child: Stack(
        children: [
          // Decorative gradient blob top-left
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                ),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF666957).withAlpha(204),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Right side decorative image area
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 176,
            child: _StarburstDecoration(),
          ),
          // Border overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withAlpha(33), width: 1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isZh ? '灵魂伴侣' : 'Soul Mate',
                      style: const TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  userSignName != null
                      ? (isZh
                            ? '$userSignName · 灵魂伴侣解析'
                            : '$userSignName · Soul Mate Analysis')
                      : (isZh ? '查看你的灵魂伴侣' : 'Find your soul mate'),
                  style: const TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Text(
                    visualization,
                    style: const TextStyle(
                      color: Color(0xFFFAFAFA),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarburstDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A0B12), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // Stars pattern
          for (final pos in [
            [0.2, 0.15, 6.0],
            [0.7, 0.25, 4.0],
            [0.5, 0.6, 8.0],
            [0.85, 0.7, 5.0],
            [0.3, 0.8, 4.0],
            [0.65, 0.45, 3.0],
          ])
            Positioned(
              left: (pos[0] * 176),
              top: (pos[1] * 100),
              child: Icon(
                Icons.star_rounded,
                color: Colors.white.withAlpha(80),
                size: pos[2],
              ),
            ),
          // Center heart icon
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CosmicColors.primary.withAlpha(80),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const Icon(
                Icons.favorite,
                color: CosmicColors.primaryLight,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignCard extends StatelessWidget {
  final String emoji;
  final String name;
  final int rank;

  const _SignCard({
    required this.emoji,
    required this.name,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final Color rankColor = rank == 1
        ? CosmicColors.secondary
        : rank == 2
        ? CosmicColors.primaryLight
        : CosmicColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: rankColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                color: rankColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TraitRow extends StatelessWidget {
  final String trait;
  const _TraitRow({required this.trait});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: CosmicColors.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            trait,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final bool isZh;
  const _AnalysisCard({required this.isZh});

  @override
  Widget build(BuildContext context) {
    final items = isZh
        ? ['你与哪些星座最有灵魂共鸣', '你在感情中的核心需求', '你的爱情风格与吸引力法则', '如何识别并吸引灵魂伴侣']
        : [
            'Which signs resonate most with your soul',
            'Your core needs in relationships',
            'Your love style and attraction patterns',
            'How to recognize and attract your soul mate',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: CosmicColors.primaryLight,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isZh ? 'AI 深度分析包含' : 'AI Analysis Includes',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: CosmicColors.primaryLight,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
