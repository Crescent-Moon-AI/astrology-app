import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';

class DivinationHubPage extends StatelessWidget {
  const DivinationHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      _DivinationItem(
        icon: '\u{1F0CF}', // 🃏
        name: l10n.divinationTarotName,
        description: l10n.divinationTarotDesc,
        route: '/tarot',
        color: CosmicColors.primary,
      ),
      _DivinationItem(
        icon: '\u{1F3B2}', // 🎲
        name: l10n.divinationDiceName,
        description: l10n.divinationDiceDesc,
        route: '/dice',
        color: const Color(0xFFE17055),
      ),
      _DivinationItem(
        icon: '\u{1F522}', // 🔢
        name: l10n.divinationNumerologyName,
        description: l10n.divinationNumerologyDesc,
        route: '/numerology',
        color: const Color(0xFF00B894),
      ),
      _DivinationItem(
        icon: '\u16A0', // ᚠ (Fehu rune)
        name: l10n.divinationRuneName,
        description: l10n.divinationRuneDesc,
        route: '/rune',
        color: const Color(0xFF6C5CE7),
      ),
      _DivinationItem(
        icon: '\u{1F0A1}', // 🂡
        name: l10n.divinationLenormandName,
        description: l10n.divinationLenormandDesc,
        route: '/lenormand',
        color: const Color(0xFFFD79A8),
      ),
      _DivinationItem(
        icon: '\u2630', // ☰
        name: l10n.divinationIChingName,
        description: l10n.divinationIChingDesc,
        route: '/iching',
        color: const Color(0xFFFDCB6E),
      ),
      _DivinationItem(
        icon: '\u6885', // 梅
        name: l10n.divinationMeihuaName,
        description: l10n.divinationMeihuaDesc,
        route: '/meihua',
        color: const Color(0xFFFF7675),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.divinationHubTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  l10n.divinationHubSubtitle,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _DivinationCard(item: items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DivinationItem {
  final String icon;
  final String name;
  final String description;
  final String route;
  final Color color;

  const _DivinationItem({
    required this.icon,
    required this.name,
    required this.description,
    required this.route,
    required this.color,
  });
}

class _DivinationCard extends StatelessWidget {
  final _DivinationItem item;

  const _DivinationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [item.color.withAlpha(30), item.color.withAlpha(10)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: item.color.withAlpha(40)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.icon,
                style: TextStyle(fontSize: 40, color: item.color),
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                item.description,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
