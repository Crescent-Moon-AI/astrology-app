import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// CTA widget displayed when birth data is missing.
class NoBirthDataPrompt extends StatelessWidget {
  const NoBirthDataPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: CosmicColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar / icon placeholder
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: CosmicColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 32,
                color: CosmicColors.primaryLight,
              ),
            ),
            const SizedBox(height: 20),

            // Message
            Text(
              isZh ? '需要出生数据' : 'Birth data required',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isZh
                  ? '请先填写您的出生日期、时间和地点，以生成星盘。'
                  : 'Please enter your birth date, time, and location to generate a chart.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // CTA button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/settings/birth-data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CosmicColors.primary,
                  foregroundColor: CosmicColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isZh ? '前往设置' : 'Go to Settings',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
