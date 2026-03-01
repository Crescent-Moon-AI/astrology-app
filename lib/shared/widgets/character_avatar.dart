import 'package:flutter/material.dart';

import '../models/expression.dart';
import '../theme/cosmic_colors.dart';

enum CharacterAvatarSize {
  sm(24),
  md(40),
  lg(120);

  const CharacterAvatarSize(this.value);
  final double value;
}

class CharacterAvatar extends StatelessWidget {
  final ExpressionId expression;
  final CharacterAvatarSize size;

  const CharacterAvatar({
    super.key,
    required this.expression,
    this.size = CharacterAvatarSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final borderWidth = size == CharacterAvatarSize.lg ? 3.0 : 1.5;
    final hasGlow = size == CharacterAvatarSize.lg;

    return Container(
      width: size.value,
      height: size.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CosmicColors.borderGlow, width: borderWidth),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: CosmicColors.primary.withAlpha(51), // 20%
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientForExpression(expression),
          ),
        ),
        child: Center(
          child: Text(
            _emojiForExpression(expression),
            style: TextStyle(fontSize: size.value * 0.45),
          ),
        ),
      ),
    );
  }

  List<Color> _gradientForExpression(ExpressionId expr) {
    switch (expr) {
      case ExpressionId.greeting:
        return [const Color(0xFF7C3AED), const Color(0xFF4F46E5)];
      case ExpressionId.thinking:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case ExpressionId.happy:
        return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
      case ExpressionId.caring:
        return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
      case ExpressionId.mysterious:
        return [const Color(0xFF7C3AED), const Color(0xFF1E1B4B)];
      case ExpressionId.surprised:
        return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
      case ExpressionId.explaining:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case ExpressionId.farewell:
        return [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)];
    }
  }

  String _emojiForExpression(ExpressionId expr) {
    switch (expr) {
      case ExpressionId.greeting:
        return '\u2728'; // ✨
      case ExpressionId.thinking:
        return '\uD83D\uDD2E'; // 🔮
      case ExpressionId.happy:
        return '\uD83D\uDE0A'; // 😊
      case ExpressionId.caring:
        return '\uD83D\uDC9C'; // 💜
      case ExpressionId.mysterious:
        return '\uD83C\uDF19'; // 🌙
      case ExpressionId.surprised:
        return '\u2B50'; // ⭐
      case ExpressionId.explaining:
        return '\uD83D\uDCD6'; // 📖
      case ExpressionId.farewell:
        return '\uD83C\uDF20'; // 🌠
    }
  }
}
