import 'package:flutter/material.dart';

import '../theme/cosmic_colors.dart';

/// A full-width ritual-style button with semi-transparent purple gradient
/// and light border. Used in tarot ritual pages (shuffle, pick, reveal).
class CosmicRitualButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CosmicRitualButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF1A1040), Color(0xFF2A1860)],
                )
              : null,
          color: isEnabled ? null : CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isEnabled
                ? const Color(0xFF4A3580).withAlpha(153) // 60%
                : CosmicColors.borderGlow,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(26),
            splashColor: CosmicColors.primaryLight.withAlpha(51), // 20%
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CosmicColors.textPrimary,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: isEnabled
                            ? CosmicColors.textPrimary
                            : CosmicColors.textTertiary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
