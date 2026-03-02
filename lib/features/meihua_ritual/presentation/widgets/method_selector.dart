import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class MethodSelector extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const MethodSelector({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CosmicColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CosmicColors.primary.withAlpha(38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: CosmicColors.primaryLight, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: CosmicColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
