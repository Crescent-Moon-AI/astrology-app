import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/planet_data.dart';
import '../../domain/models/house_data.dart';

/// Personality tag chips derived from chart data, matching the real app's
/// "星盘概览" section with tags like 温和有礼, 内敛要强, etc.
class PersonalityTags extends StatelessWidget {
  final List<PlanetData> planets;
  final AnglesData angles;

  const PersonalityTags({
    super.key,
    required this.planets,
    required this.angles,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final tags = _deriveTags(isZh);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _TagChip(label: tag)).toList(),
    );
  }

  List<String> _deriveTags(bool isZh) {
    final tags = <String>[];

    // Find key planets
    PlanetData? sun, moon, mercury, venus, mars;
    for (final p in planets) {
      switch (p.name) {
        case 'Sun':
          sun = p;
        case 'Moon':
          moon = p;
        case 'Mercury':
          mercury = p;
        case 'Venus':
          venus = p;
        case 'Mars':
          mars = p;
      }
    }

    // Derive personality tags from Sun sign
    if (sun != null) {
      tags.add(
        isZh
            ? _zhSunTraits[sun.sign] ?? '独特个性'
            : _enSunTraits[sun.sign] ?? 'Unique',
      );
    }

    // Moon sign → emotional trait
    if (moon != null) {
      tags.add(
        isZh
            ? _zhMoonTraits[moon.sign] ?? '情感丰富'
            : _enMoonTraits[moon.sign] ?? 'Emotional',
      );
    }

    // ASC → external presentation
    tags.add(
      isZh
          ? _zhAscTraits[angles.ascSign] ?? '气质独特'
          : _enAscTraits[angles.ascSign] ?? 'Distinctive',
    );

    // Mercury → communication style
    if (mercury != null) {
      tags.add(
        isZh
            ? _zhMercuryTraits[mercury.sign] ?? '善于表达'
            : _enMercuryTraits[mercury.sign] ?? 'Articulate',
      );
    }

    // Venus → relationship approach
    if (venus != null) {
      tags.add(
        isZh
            ? _zhVenusTraits[venus.sign] ?? '有魅力'
            : _enVenusTraits[venus.sign] ?? 'Attractive',
      );
    }

    // Mars → action style
    if (mars != null) {
      tags.add(
        isZh
            ? _zhMarsTraits[mars.sign] ?? '有行动力'
            : _enMarsTraits[mars.sign] ?? 'Driven',
      );
    }

    return tags;
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CosmicColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

const _zhSunTraits = <String, String>{
  'Aries': '热血沸腾',
  'Taurus': '稳重踏实',
  'Gemini': '灵活多变',
  'Cancer': '温和有礼',
  'Leo': '自信大方',
  'Virgo': '细致入微',
  'Libra': '优雅和谐',
  'Scorpio': '内敛要强',
  'Sagittarius': '自由洒脱',
  'Capricorn': '沉稳务实',
  'Aquarius': '特立独行',
  'Pisces': '浪漫多情',
};

const _enSunTraits = <String, String>{
  'Aries': 'Bold & Fiery',
  'Taurus': 'Steady & Reliable',
  'Gemini': 'Quick & Versatile',
  'Cancer': 'Warm & Caring',
  'Leo': 'Confident & Generous',
  'Virgo': 'Precise & Thoughtful',
  'Libra': 'Graceful & Fair',
  'Scorpio': 'Intense & Driven',
  'Sagittarius': 'Free & Adventurous',
  'Capricorn': 'Grounded & Ambitious',
  'Aquarius': 'Independent & Original',
  'Pisces': 'Dreamy & Empathetic',
};

const _zhMoonTraits = <String, String>{
  'Aries': '急脾气',
  'Taurus': '重安全感',
  'Gemini': '情绪多变',
  'Cancer': '感性细腻',
  'Leo': '情感强烈',
  'Virgo': '心思缜密',
  'Libra': '追求平衡',
  'Scorpio': '情感深沉',
  'Sagittarius': '心态乐观',
  'Capricorn': '遇事先稳',
  'Aquarius': '情绪独立',
  'Pisces': '直觉敏锐',
};

const _enMoonTraits = <String, String>{
  'Aries': 'Quick Tempered',
  'Taurus': 'Security-seeking',
  'Gemini': 'Moody',
  'Cancer': 'Deeply Feeling',
  'Leo': 'Emotionally Intense',
  'Virgo': 'Detail-oriented',
  'Libra': 'Balance-seeking',
  'Scorpio': 'Emotionally Deep',
  'Sagittarius': 'Optimistic',
  'Capricorn': 'Emotionally Steady',
  'Aquarius': 'Emotionally Free',
  'Pisces': 'Highly Intuitive',
};

const _zhAscTraits = <String, String>{
  'Aries': '果断利落',
  'Taurus': '从容优雅',
  'Gemini': '机智幽默',
  'Cancer': '亲和力强',
  'Leo': '气场十足',
  'Virgo': '谦逊低调',
  'Libra': '温文尔雅',
  'Scorpio': '神秘感强',
  'Sagittarius': '热情开朗',
  'Capricorn': '重责任',
  'Aquarius': '个性鲜明',
  'Pisces': '温柔梦幻',
};

const _enAscTraits = <String, String>{
  'Aries': 'Decisive',
  'Taurus': 'Composed',
  'Gemini': 'Witty',
  'Cancer': 'Approachable',
  'Leo': 'Commanding',
  'Virgo': 'Modest',
  'Libra': 'Refined',
  'Scorpio': 'Enigmatic',
  'Sagittarius': 'Enthusiastic',
  'Capricorn': 'Responsible',
  'Aquarius': 'Distinct',
  'Pisces': 'Ethereal',
};

const _zhMercuryTraits = <String, String>{
  'Aries': '说话直接',
  'Taurus': '思路清晰',
  'Gemini': '能说会道',
  'Cancer': '善于倾听',
  'Leo': '表达有力',
  'Virgo': '逻辑严密',
  'Libra': '善于调解',
  'Scorpio': '洞察力强',
  'Sagittarius': '思维开阔',
  'Capricorn': '言简意赅',
  'Aquarius': '思想前卫',
  'Pisces': '想象丰富',
};

const _enMercuryTraits = <String, String>{
  'Aries': 'Direct Speaker',
  'Taurus': 'Clear Thinker',
  'Gemini': 'Eloquent',
  'Cancer': 'Good Listener',
  'Leo': 'Expressive',
  'Virgo': 'Analytical',
  'Libra': 'Diplomatic',
  'Scorpio': 'Perceptive',
  'Sagittarius': 'Open-minded',
  'Capricorn': 'Concise',
  'Aquarius': 'Visionary',
  'Pisces': 'Imaginative',
};

const _zhVenusTraits = <String, String>{
  'Aries': '勇敢追爱',
  'Taurus': '享受生活',
  'Gemini': '恋爱轻松',
  'Cancer': '恋家温暖',
  'Leo': '浪漫大方',
  'Virgo': '含蓄内敛',
  'Libra': '审美出众',
  'Scorpio': '深情专一',
  'Sagittarius': '热情自由',
  'Capricorn': '感情务实',
  'Aquarius': '爱情理性',
  'Pisces': '浪漫至极',
};

const _enVenusTraits = <String, String>{
  'Aries': 'Love Chaser',
  'Taurus': 'Pleasure-seeking',
  'Gemini': 'Lighthearted',
  'Cancer': 'Homebody',
  'Leo': 'Romantic',
  'Virgo': 'Reserved',
  'Libra': 'Aesthetic',
  'Scorpio': 'Devoted',
  'Sagittarius': 'Warmly Free',
  'Capricorn': 'Pragmatic Love',
  'Aquarius': 'Rational Love',
  'Pisces': 'Deeply Romantic',
};

const _zhMarsTraits = <String, String>{
  'Aries': '行动派',
  'Taurus': '坚持到底',
  'Gemini': '灵活应变',
  'Cancer': '保护欲强',
  'Leo': '充满干劲',
  'Virgo': '精益求精',
  'Libra': '策略行动',
  'Scorpio': '意志坚定',
  'Sagittarius': '敢于冒险',
  'Capricorn': '目标导向',
  'Aquarius': '特立独行',
  'Pisces': '温柔力量',
};

const _enMarsTraits = <String, String>{
  'Aries': 'Action-taker',
  'Taurus': 'Persistent',
  'Gemini': 'Adaptable',
  'Cancer': 'Protective',
  'Leo': 'Energetic',
  'Virgo': 'Perfectionist',
  'Libra': 'Strategic',
  'Scorpio': 'Iron-willed',
  'Sagittarius': 'Risk-taker',
  'Capricorn': 'Goal-driven',
  'Aquarius': 'Unconventional',
  'Pisces': 'Gentle Strength',
};
