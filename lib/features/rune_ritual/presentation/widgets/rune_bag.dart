import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class RuneBag extends StatefulWidget {
  final VoidCallback? onTap;

  const RuneBag({super.key, this.onTap});

  @override
  State<RuneBag> createState() => _RuneBagState();
}

class _RuneBagState extends State<RuneBag> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 140,
              height: 160,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3A2A5E), Color(0xFF1A0A3E)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: CosmicColors.primaryLight.withAlpha(102),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.primary.withAlpha(77),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\u16A0', // ᚠ Fehu
                      style: TextStyle(
                        fontSize: 40,
                        color: CosmicColors.secondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '...',
                      style: TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
