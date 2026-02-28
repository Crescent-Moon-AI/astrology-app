import 'package:flutter/material.dart';

import '../theme/cosmic_colors.dart';

/// A gradient call-to-action button with pill shape and optional loading state.
class CosmicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CosmicButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? CosmicColors.primaryGradient
            : null,
        color: onPressed == null ? CosmicColors.surfaceElevated : null,
        borderRadius: BorderRadius.circular(24),
        boxShadow: onPressed != null
            ? const [
                BoxShadow(
                  color: Color(0x4D6C5CE7), // primary @ 30%
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(24),
          splashColor: CosmicColors.primaryLight.withValues(alpha: 0.3),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
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
