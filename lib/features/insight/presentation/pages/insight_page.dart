import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  l10n.insightTitle,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                // Jung quote
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        color: CosmicColors.primaryLight,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.insightQuote,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.insightQuoteAuthor,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // My Chart card
                _InsightCard(
                  icon: Icons.circle_outlined,
                  title: l10n.insightMyChart,
                  subtitle: l10n.insightComingSoon,
                  gradient: [CosmicColors.primary, CosmicColors.primaryLight],
                ),
                const SizedBox(height: 12),
                // Synastry card
                _InsightCard(
                  icon: Icons.compare_arrows_rounded,
                  title: l10n.insightSynastry,
                  subtitle: l10n.insightComingSoon,
                  gradient: [const Color(0xFFE17055), const Color(0xFFFDCB6E)],
                ),
                const SizedBox(height: 12),
                // Deep explore
                _InsightCard(
                  icon: Icons.auto_graph_rounded,
                  title: l10n.insightDeepExplore,
                  subtitle: l10n.insightComingSoon,
                  gradient: [const Color(0xFF00CEC9), const Color(0xFF55EFC4)],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradient[0].withAlpha(38), gradient[1].withAlpha(13)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gradient[0].withAlpha(26)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: gradient[0].withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: gradient[0], size: 28),
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
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: CosmicColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
