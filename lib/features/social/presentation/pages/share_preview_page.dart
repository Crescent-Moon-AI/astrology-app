import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/shared_card.dart';

class SharePreviewPage extends StatelessWidget {
  final SharedCard card;

  const SharePreviewPage({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.shareTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card preview
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CosmicColors.borderGlow, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: card.imageUrl != null
                    ? Image.network(
                        card.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _PlaceholderCard(cardType: card.cardType, isZh: isZh),
                      )
                    : _PlaceholderCard(cardType: card.cardType, isZh: isZh),
              ),
            ),
            const SizedBox(height: 16),

            // Share URL display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: CosmicColors.surfaceElevated,
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 18, color: CosmicColors.primaryLight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      card.shareUrl,
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Expiry date
            Text(
              l10n.shareExpires(
                DateFormat('yyyy-MM-dd').format(card.expiresAt),
              ),
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Share button (gradient CTA)
            Container(
              decoration: BoxDecoration(
                gradient: CosmicColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _copyLink(context, l10n),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share,
                            color: CosmicColors.textPrimary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.shareCard,
                          style: const TextStyle(
                            color: CosmicColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.shareSaveImage)),
                      );
                    },
                    icon: const Icon(Icons.save_alt, size: 18),
                    label: Text(l10n.shareSaveImage),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CosmicColors.primaryLight,
                      side: const BorderSide(color: CosmicColors.borderGlow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyLink(context, l10n),
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(l10n.shareCopyLink),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CosmicColors.primaryLight,
                      side: const BorderSide(color: CosmicColors.borderGlow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyLink(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: card.shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shareLinkCopied)),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String cardType;
  final bool isZh;

  const _PlaceholderCard({required this.cardType, required this.isZh});

  @override
  Widget build(BuildContext context) {
    final (emoji, label) = switch (cardType) {
      'chart' => ('\uD83C\uDF1F', isZh ? '星盘' : 'Birth Chart'),
      'horoscope' => ('\u2728', isZh ? '运势' : 'Horoscope'),
      'tarot' => ('\uD83C\uDCCF', isZh ? '塔罗牌' : 'Tarot Reading'),
      'synastry' => ('\uD83D\uDC95', isZh ? '合盘' : 'Synastry'),
      _ => ('\uD83C\uDF0C', isZh ? '分享卡片' : 'Share Card'),
    };

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CosmicColors.primary.withValues(alpha: 0.2),
            CosmicColors.background,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
