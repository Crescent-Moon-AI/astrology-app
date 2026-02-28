import 'package:flutter/material.dart';

class TarotCardBack extends StatelessWidget {
  final double width;
  final double height;

  const TarotCardBack({
    super.key,
    this.width = 120,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D1B69),
            Color(0xFF1A0A3E),
            Color(0xFF4A1A7A),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A1A7A).withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative corner elements
          Positioned(
            top: 8,
            left: 8,
            child: _cornerDecoration(),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Transform.flip(
              flipX: true,
              child: _cornerDecoration(),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Transform.flip(
              flipY: true,
              child: _cornerDecoration(),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Transform.flip(
              flipX: true,
              flipY: true,
              child: _cornerDecoration(),
            ),
          ),
          // Central star/moon icon
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u2726',
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFFD4AF37),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '\u263D',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cornerDecoration() {
    return const Text(
      '\u2727',
      style: TextStyle(
        fontSize: 12,
        color: Color(0xFFD4AF37),
      ),
    );
  }
}
