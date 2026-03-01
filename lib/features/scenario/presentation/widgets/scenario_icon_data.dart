import 'package:flutter/material.dart';

/// Visual configuration for each scenario, mapping slugs to unique
/// icons, emojis, and gradient color pairs for card backgrounds.
class ScenarioVisual {
  final IconData icon;
  final String emoji;
  final List<Color> gradient;

  const ScenarioVisual({
    required this.icon,
    required this.emoji,
    required this.gradient,
  });
}

/// Category-level visual config for filter chips and headers.
class CategoryVisual {
  final IconData icon;
  final String emoji;
  final Color accentColor;

  const CategoryVisual({
    required this.icon,
    required this.emoji,
    required this.accentColor,
  });
}

const _kDefaultVisual = ScenarioVisual(
  icon: Icons.auto_awesome,
  emoji: '\u2728', // ✨
  gradient: [Color(0xFF6C5CE7), Color(0xFF8B5CF6)],
);

/// Maps scenario slugs to unique visual configurations.
ScenarioVisual getScenarioVisual(String slug) {
  return _scenarioVisuals[slug] ?? _kDefaultVisual;
}

/// Maps category icon names (from backend) to visual configurations.
CategoryVisual getCategoryVisual(String iconName) {
  return _categoryVisuals[iconName] ??
      const CategoryVisual(
        icon: Icons.auto_awesome,
        emoji: '\u2728',
        accentColor: Color(0xFF6C5CE7),
      );
}

const Map<String, ScenarioVisual> _scenarioVisuals = {
  // Backend slugs use kebab-case
  'moving-past-heartbreak': ScenarioVisual(
    icon: Icons.heart_broken_rounded,
    emoji: '\uD83D\uDC94', // 💔
    gradient: [Color(0xFFE91E63), Color(0xFF9C27B0)],
  ),
  'love-compatibility': ScenarioVisual(
    icon: Icons.favorite_rounded,
    emoji: '\uD83D\uDC95', // 💕
    gradient: [Color(0xFFFF6B9D), Color(0xFFC44569)],
  ),
  'weekly-love': ScenarioVisual(
    icon: Icons.favorite_rounded,
    emoji: '\uD83D\uDC98', // 💘
    gradient: [Color(0xFFFF6B9D), Color(0xFFC44569)],
  ),
  'career-direction': ScenarioVisual(
    icon: Icons.rocket_launch_rounded,
    emoji: '\uD83D\uDE80', // 🚀
    gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
  ),
  'career-guide': ScenarioVisual(
    icon: Icons.star_rounded,
    emoji: '\uD83C\uDF1F', // 🌟
    gradient: [Color(0xFF4FACFE), Color(0xFF667EEA)],
  ),
  'job-change-timing': ScenarioVisual(
    icon: Icons.swap_horiz_rounded,
    emoji: '\uD83D\uDD04', // 🔄
    gradient: [Color(0xFF43E97B), Color(0xFF38F9D7)],
  ),
  'a-small-decision': ScenarioVisual(
    icon: Icons.balance_rounded,
    emoji: '\u2696\uFE0F', // ⚖️
    gradient: [Color(0xFFFDA085), Color(0xFFF6D365)],
  ),
  'daily-fortune': ScenarioVisual(
    icon: Icons.wb_sunny_rounded,
    emoji: '\u2600\uFE0F', // ☀️
    gradient: [Color(0xFFFFD700), Color(0xFFFF8C00)],
  ),
  'monthly-wealth': ScenarioVisual(
    icon: Icons.paid_rounded,
    emoji: '\uD83D\uDCB0', // 💰
    gradient: [Color(0xFFFFD700), Color(0xFFF59E0B)],
  ),
  'mercury-retrograde': ScenarioVisual(
    icon: Icons.autorenew_rounded,
    emoji: '\uD83C\uDF00', // 🌀
    gradient: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
  ),
  'energy-tuning': ScenarioVisual(
    icon: Icons.self_improvement_rounded,
    emoji: '\uD83E\uDDD8', // 🧘
    gradient: [Color(0xFF10B981), Color(0xFF06B6D4)],
  ),
  'new-moon-wish': ScenarioVisual(
    icon: Icons.dark_mode_rounded,
    emoji: '\uD83C\uDF11', // 🌑
    gradient: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
  ),
  'know-yourself': ScenarioVisual(
    icon: Icons.psychology_rounded,
    emoji: '\uD83D\uDD2E', // 🔮
    gradient: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
  ),
  'life-purpose': ScenarioVisual(
    icon: Icons.explore_rounded,
    emoji: '\uD83C\uDF0C', // 🌌
    gradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
  ),
  'social-moments': ScenarioVisual(
    icon: Icons.people_rounded,
    emoji: '\uD83E\uDD1D', // 🤝
    gradient: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  ),
  'family-harmony': ScenarioVisual(
    icon: Icons.home_rounded,
    emoji: '\uD83C\uDFE0', // 🏠
    gradient: [Color(0xFF10B981), Color(0xFF059669)],
  ),
};

const Map<String, CategoryVisual> _categoryVisuals = {
  'heart': CategoryVisual(
    icon: Icons.favorite_rounded,
    emoji: '\u2764\uFE0F',
    accentColor: Color(0xFFE91E63),
  ),
  'briefcase': CategoryVisual(
    icon: Icons.work_rounded,
    emoji: '\uD83D\uDCBC',
    accentColor: Color(0xFF4FACFE),
  ),
  'coins': CategoryVisual(
    icon: Icons.paid_rounded,
    emoji: '\uD83D\uDCB0',
    accentColor: Color(0xFFFFD700),
  ),
  'heart_pulse': CategoryVisual(
    icon: Icons.monitor_heart_rounded,
    emoji: '\uD83D\uDC9A',
    accentColor: Color(0xFF10B981),
  ),
  'sparkles': CategoryVisual(
    icon: Icons.auto_awesome_rounded,
    emoji: '\u2728',
    accentColor: Color(0xFF7C3AED),
  ),
  'dice': CategoryVisual(
    icon: Icons.casino_rounded,
    emoji: '\uD83C\uDFB2',
    accentColor: Color(0xFFFDA085),
  ),
  'mirror': CategoryVisual(
    icon: Icons.self_improvement_rounded,
    emoji: '\uD83E\uDDD8',
    accentColor: Color(0xFF7C3AED),
  ),
  'people': CategoryVisual(
    icon: Icons.people_rounded,
    emoji: '\uD83D\uDC65',
    accentColor: Color(0xFF06B6D4),
  ),
};
