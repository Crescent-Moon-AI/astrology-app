import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shareTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card preview
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: card.imageUrl != null
                    ? Image.network(
                        card.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _PlaceholderCard(cardType: card.cardType),
                      )
                    : _PlaceholderCard(cardType: card.cardType),
              ),
            ),
            const SizedBox(height: 16),

            // Share URL display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        card.shareUrl,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Expiry date
            Text(
              l10n.shareExpires(
                DateFormat('yyyy-MM-dd').format(card.expiresAt),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                // Share button (copies link for now)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _copyLink(context, l10n),
                    icon: const Icon(Icons.share),
                    label: Text(l10n.shareCard),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Save image placeholder
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.shareSaveImage)),
                      );
                    },
                    icon: const Icon(Icons.save_alt),
                    label: Text(l10n.shareSaveImage),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyLink(context, l10n),
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.shareCopyLink),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
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

  const _PlaceholderCard({required this.cardType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, label) = switch (cardType) {
      'chart' => (Icons.pie_chart, 'Birth Chart'),
      'horoscope' => (Icons.stars, 'Horoscope'),
      'tarot' => (Icons.style, 'Tarot Reading'),
      'synastry' => (Icons.favorite, 'Synastry'),
      _ => (Icons.share, 'Share Card'),
    };

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
