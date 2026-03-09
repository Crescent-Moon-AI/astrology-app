import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/planet_data.dart';
import '../../domain/models/asteroid_data.dart';
import '../../domain/models/house_data.dart';

/// A 3-column grid of planet cards showing sign symbol, planet+sign name,
/// and a short keyword — matching the real app's "星盘概览" layout.
class PlanetKeywordGrid extends StatelessWidget {
  final List<PlanetData> planets;
  final List<AsteroidData> asteroids;
  final AnglesData angles;

  const PlanetKeywordGrid({
    super.key,
    required this.planets,
    required this.asteroids,
    required this.angles,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final items = _buildItems(isZh);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.05,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _PlanetCard(item: items[index]),
    );
  }

  List<_PlanetItem> _buildItems(bool isZh) {
    final items = <_PlanetItem>[];

    // Key planets to display: Sun, Moon, ASC, Venus, Mars, Mercury
    final keyPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
    for (final planet in planets) {
      if (keyPlanets.contains(planet.name)) {
        items.add(
          _PlanetItem(
            signSymbol: _signSymbolColor(planet.sign),
            planetSymbol: planet.symbol,
            label: isZh
                ? '${planet.symbol}${planet.nameCn}${planet.signCn}'
                : '${planet.symbol}${planet.name} in ${planet.sign}',
            keyword: _planetSignKeyword(planet.name, planet.sign, isZh),
            signGlyph: planet.signSymbol,
          ),
        );
      }
    }

    // Insert ASC at position 2 (after Sun and Moon)
    final ascItem = _PlanetItem(
      signSymbol: _signSymbolColor(angles.ascSign),
      planetSymbol: '\u2191',
      label: isZh
          ? '\u2191${isZh ? "上升" : "ASC"}${isZh ? angles.ascSignCn : angles.ascSign}'
          : '\u2191ASC in ${angles.ascSign}',
      keyword: _ascKeyword(angles.ascSign, isZh),
      signGlyph: _signToGlyph(angles.ascSign),
    );
    if (items.length >= 2) {
      items.insert(2, ascItem);
    } else {
      items.add(ascItem);
    }

    // Add key asteroids: North Node, Juno, Part of Fortune
    final keyAsteroids = ['North Node', 'Juno', 'Part of Fortune'];
    for (final asteroid in asteroids) {
      if (keyAsteroids.contains(asteroid.name)) {
        items.add(
          _PlanetItem(
            signSymbol: _signSymbolColor(asteroid.sign),
            planetSymbol: asteroid.symbol,
            label: isZh
                ? '${asteroid.symbol}${asteroid.nameCn}${asteroid.signCn}'
                : '${asteroid.symbol}${asteroid.name} in ${asteroid.sign}',
            keyword: _asteroidSignKeyword(asteroid.name, asteroid.sign, isZh),
            signGlyph: asteroid.signSymbol,
          ),
        );
      }
    }

    // Ensure we show at most 9 items (3x3 grid)
    if (items.length > 9) return items.sublist(0, 9);
    return items;
  }
}

class _PlanetItem {
  final Color signSymbol;
  final String planetSymbol;
  final String label;
  final String keyword;
  final String signGlyph;

  const _PlanetItem({
    required this.signSymbol,
    required this.planetSymbol,
    required this.label,
    required this.keyword,
    required this.signGlyph,
  });
}

class _PlanetCard extends StatelessWidget {
  final _PlanetItem item;
  const _PlanetCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sign glyph at top
          Text(
            item.signGlyph,
            style: TextStyle(color: item.signSymbol, fontSize: 20),
          ),
          const SizedBox(height: 6),
          // Planet + Sign name
          Text(
            item.label,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          // Keyword
          Text(
            item.keyword,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

// --- Lookup tables ---

Color _signSymbolColor(String sign) {
  const fireColor = CosmicColors.fireSigns;
  const earthColor = CosmicColors.earthSigns;
  const airColor = CosmicColors.airSigns;
  const waterColor = CosmicColors.waterSigns;

  return switch (sign) {
    'Aries' || 'Leo' || 'Sagittarius' => fireColor,
    'Taurus' || 'Virgo' || 'Capricorn' => earthColor,
    'Gemini' || 'Libra' || 'Aquarius' => airColor,
    'Cancer' || 'Scorpio' || 'Pisces' => waterColor,
    _ => CosmicColors.textSecondary,
  };
}

String _signToGlyph(String sign) {
  return switch (sign) {
    'Aries' => '\u2648',
    'Taurus' => '\u2649',
    'Gemini' => '\u264A',
    'Cancer' => '\u264B',
    'Leo' => '\u264C',
    'Virgo' => '\u264D',
    'Libra' => '\u264E',
    'Scorpio' => '\u264F',
    'Sagittarius' => '\u2650',
    'Capricorn' => '\u2651',
    'Aquarius' => '\u2652',
    'Pisces' => '\u2653',
    _ => '?',
  };
}

String _planetSignKeyword(String planet, String sign, bool isZh) {
  final key = '$planet:$sign';
  if (isZh) {
    return _zhKeywords[key] ?? '';
  }
  return _enKeywords[key] ?? '';
}

String _ascKeyword(String sign, bool isZh) {
  if (isZh) {
    return _zhAscKeywords[sign] ?? '';
  }
  return _enAscKeywords[sign] ?? '';
}

String _asteroidSignKeyword(String asteroid, String sign, bool isZh) {
  // Simplified keywords for asteroids
  final key = '$asteroid:$sign';
  if (isZh) {
    return _zhAsteroidKeywords[key] ?? _zhAsteroidDefaults[asteroid] ?? '';
  }
  return _enAsteroidKeywords[key] ?? _enAsteroidDefaults[asteroid] ?? '';
}

const _zhKeywords = <String, String>{
  // Sun
  'Sun:Aries': '热血沸腾', 'Sun:Taurus': '稳重踏实', 'Sun:Gemini': '灵活多变',
  'Sun:Cancer': '温暖体贴', 'Sun:Leo': '自信闪耀', 'Sun:Virgo': '细致完美',
  'Sun:Libra': '优雅和谐', 'Sun:Scorpio': '深邃坚定', 'Sun:Sagittarius': '自由奔放',
  'Sun:Capricorn': '沉稳务实', 'Sun:Aquarius': '独立创新', 'Sun:Pisces': '浪漫直觉',
  // Moon
  'Moon:Aries': '情绪冲动', 'Moon:Taurus': '安全感强', 'Moon:Gemini': '情绪多变',
  'Moon:Cancer': '敏感温柔', 'Moon:Leo': '情感炽热', 'Moon:Virgo': '情绪谨慎',
  'Moon:Libra': '追求平衡', 'Moon:Scorpio': '情感深沉', 'Moon:Sagittarius': '情绪乐观',
  'Moon:Capricorn': '需要成就', 'Moon:Aquarius': '情绪独立', 'Moon:Pisces': '感性多梦',
  // Mercury
  'Mercury:Aries': '思维敏捷', 'Mercury:Taurus': '思考稳健', 'Mercury:Gemini': '善于沟通',
  'Mercury:Cancer': '直觉思维', 'Mercury:Leo': '表达自信', 'Mercury:Virgo': '分析严谨',
  'Mercury:Libra': '思维公正',
  'Mercury:Scorpio': '洞察入微',
  'Mercury:Sagittarius': '思维开阔',
  'Mercury:Capricorn': '逻辑清晰',
  'Mercury:Aquarius': '思维超前',
  'Mercury:Pisces': '想象丰富',
  // Venus
  'Venus:Aries': '热烈追求', 'Venus:Taurus': '感官享受', 'Venus:Gemini': '轻松恋爱',
  'Venus:Cancer': '恋家温柔', 'Venus:Leo': '浪漫大方', 'Venus:Virgo': '含蓄细腻',
  'Venus:Libra': '优雅迷人', 'Venus:Scorpio': '深情专一', 'Venus:Sagittarius': '自由热情',
  'Venus:Capricorn': '务实忠诚', 'Venus:Aquarius': '理性爱情', 'Venus:Pisces': '梦幻浪漫',
  // Mars
  'Mars:Aries': '竞争力强', 'Mars:Taurus': '持久耐力', 'Mars:Gemini': '灵活行动',
  'Mars:Cancer': '保护本能', 'Mars:Leo': '充满激情', 'Mars:Virgo': '精准高效',
  'Mars:Libra': '策略行动', 'Mars:Scorpio': '坚韧不拔', 'Mars:Sagittarius': '冒险进取',
  'Mars:Capricorn': '目标坚定', 'Mars:Aquarius': '独特方式', 'Mars:Pisces': '柔和行动',
};

const _enKeywords = <String, String>{
  'Sun:Aries': 'Bold Energy',
  'Sun:Taurus': 'Steady',
  'Sun:Gemini': 'Versatile',
  'Sun:Cancer': 'Nurturing',
  'Sun:Leo': 'Confident',
  'Sun:Virgo': 'Precise',
  'Sun:Libra': 'Harmonious',
  'Sun:Scorpio': 'Intense',
  'Sun:Sagittarius': 'Adventurous',
  'Sun:Capricorn': 'Ambitious',
  'Sun:Aquarius': 'Innovative',
  'Sun:Pisces': 'Dreamy',
  'Moon:Aries': 'Impulsive',
  'Moon:Taurus': 'Secure',
  'Moon:Gemini': 'Changeable',
  'Moon:Cancer': 'Sensitive',
  'Moon:Leo': 'Passionate',
  'Moon:Virgo': 'Cautious',
  'Moon:Libra': 'Balanced',
  'Moon:Scorpio': 'Deep',
  'Moon:Sagittarius': 'Optimistic',
  'Moon:Capricorn': 'Driven',
  'Moon:Aquarius': 'Detached',
  'Moon:Pisces': 'Intuitive',
  'Mercury:Aries': 'Quick Mind',
  'Mercury:Taurus': 'Grounded',
  'Mercury:Gemini': 'Witty',
  'Mercury:Cancer': 'Intuitive',
  'Mercury:Leo': 'Expressive',
  'Mercury:Virgo': 'Analytical',
  'Mercury:Libra': 'Diplomatic',
  'Mercury:Scorpio': 'Perceptive',
  'Mercury:Sagittarius': 'Broad',
  'Mercury:Capricorn': 'Logical',
  'Mercury:Aquarius': 'Visionary',
  'Mercury:Pisces': 'Imaginative',
  'Venus:Aries': 'Passionate',
  'Venus:Taurus': 'Sensual',
  'Venus:Gemini': 'Playful',
  'Venus:Cancer': 'Devoted',
  'Venus:Leo': 'Generous',
  'Venus:Virgo': 'Modest',
  'Venus:Libra': 'Charming',
  'Venus:Scorpio': 'Loyal',
  'Venus:Sagittarius': 'Free',
  'Venus:Capricorn': 'Committed',
  'Venus:Aquarius': 'Independent',
  'Venus:Pisces': 'Romantic',
  'Mars:Aries': 'Competitive',
  'Mars:Taurus': 'Persistent',
  'Mars:Gemini': 'Agile',
  'Mars:Cancer': 'Protective',
  'Mars:Leo': 'Fierce',
  'Mars:Virgo': 'Efficient',
  'Mars:Libra': 'Strategic',
  'Mars:Scorpio': 'Relentless',
  'Mars:Sagittarius': 'Daring',
  'Mars:Capricorn': 'Disciplined',
  'Mars:Aquarius': 'Unconventional',
  'Mars:Pisces': 'Gentle',
};

const _zhAscKeywords = <String, String>{
  'Aries': '果断先锋',
  'Taurus': '沉稳优雅',
  'Gemini': '机智灵活',
  'Cancer': '亲切感',
  'Leo': '气场强大',
  'Virgo': '谦逊细心',
  'Libra': '迷人和善',
  'Scorpio': '神秘深邃',
  'Sagittarius': '乐观热情',
  'Capricorn': '可靠沉稳',
  'Aquarius': '特立独行',
  'Pisces': '温柔梦幻',
};

const _enAscKeywords = <String, String>{
  'Aries': 'Pioneer',
  'Taurus': 'Composed',
  'Gemini': 'Curious',
  'Cancer': 'Warm',
  'Leo': 'Radiant',
  'Virgo': 'Humble',
  'Libra': 'Graceful',
  'Scorpio': 'Mysterious',
  'Sagittarius': 'Optimistic',
  'Capricorn': 'Reliable',
  'Aquarius': 'Unique',
  'Pisces': 'Gentle',
};

const _zhAsteroidDefaults = <String, String>{
  'North Node': '人生方向',
  'Juno': '婚姻模式',
  'Part of Fortune': '幸运所在',
};

const _enAsteroidDefaults = <String, String>{
  'North Node': 'Life Path',
  'Juno': 'Partnership',
  'Part of Fortune': 'Fortune',
};

const _zhAsteroidKeywords = <String, String>{
  'North Node:Aries': '学会独立',
  'North Node:Taurus': '学会稳定',
  'North Node:Gemini': '学会沟通',
  'North Node:Cancer': '学会照顾',
  'North Node:Leo': '学会自信',
  'North Node:Virgo': '学会服务',
  'North Node:Libra': '学会合作',
  'North Node:Scorpio': '学会深入',
  'North Node:Sagittarius': '学会探索',
  'North Node:Capricorn': '学会担当',
  'North Node:Aquarius': '学会创新',
  'North Node:Pisces': '学会信任',
  'Juno:Aries': '独立型',
  'Juno:Taurus': '稳定型',
  'Juno:Gemini': '沟通型',
  'Juno:Cancer': '家庭型',
  'Juno:Leo': '浪漫型',
  'Juno:Virgo': '服务型',
  'Juno:Libra': '平等型',
  'Juno:Scorpio': '深入型',
  'Juno:Sagittarius': '自由型',
  'Juno:Capricorn': '责任型',
  'Juno:Aquarius': '创新型',
  'Juno:Pisces': '浪漫型',
  'Part of Fortune:Aries': '独立自主',
  'Part of Fortune:Taurus': '物质丰盛',
  'Part of Fortune:Gemini': '信息互通',
  'Part of Fortune:Cancer': '家庭幸福',
  'Part of Fortune:Leo': '创意表现',
  'Part of Fortune:Virgo': '精益求精',
  'Part of Fortune:Libra': '和谐关系',
  'Part of Fortune:Scorpio': '深度转化',
  'Part of Fortune:Sagittarius': '自由探索',
  'Part of Fortune:Capricorn': '事业成就',
  'Part of Fortune:Aquarius': '群体贡献',
  'Part of Fortune:Pisces': '灵性成长',
};

const _enAsteroidKeywords = <String, String>{
  'North Node:Aries': 'Independence',
  'North Node:Taurus': 'Stability',
  'North Node:Gemini': 'Communication',
  'North Node:Cancer': 'Nurturing',
  'North Node:Leo': 'Self-expression',
  'North Node:Virgo': 'Service',
  'North Node:Libra': 'Partnership',
  'North Node:Scorpio': 'Depth',
  'North Node:Sagittarius': 'Exploration',
  'North Node:Capricorn': 'Mastery',
  'North Node:Aquarius': 'Innovation',
  'North Node:Pisces': 'Surrender',
  'Juno:Aries': 'Independent',
  'Juno:Taurus': 'Stable',
  'Juno:Gemini': 'Communicative',
  'Juno:Cancer': 'Domestic',
  'Juno:Leo': 'Romantic',
  'Juno:Virgo': 'Service',
  'Juno:Libra': 'Equal',
  'Juno:Scorpio': 'Intense',
  'Juno:Sagittarius': 'Free',
  'Juno:Capricorn': 'Committed',
  'Juno:Aquarius': 'Unconventional',
  'Juno:Pisces': 'Dreamy',
  'Part of Fortune:Aries': 'Self-reliance',
  'Part of Fortune:Taurus': 'Abundance',
  'Part of Fortune:Gemini': 'Networking',
  'Part of Fortune:Cancer': 'Home',
  'Part of Fortune:Leo': 'Creativity',
  'Part of Fortune:Virgo': 'Mastery',
  'Part of Fortune:Libra': 'Harmony',
  'Part of Fortune:Scorpio': 'Transformation',
  'Part of Fortune:Sagittarius': 'Freedom',
  'Part of Fortune:Capricorn': 'Achievement',
  'Part of Fortune:Aquarius': 'Community',
  'Part of Fortune:Pisces': 'Spirituality',
};
