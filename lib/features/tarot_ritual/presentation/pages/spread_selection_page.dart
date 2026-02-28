import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../domain/models/spread_type.dart';
import '../providers/tarot_ritual_providers.dart';

class SpreadSelectionPage extends ConsumerStatefulWidget {
  final String conversationId;

  const SpreadSelectionPage({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<SpreadSelectionPage> createState() =>
      _SpreadSelectionPageState();
}

class _SpreadSelectionPageState extends ConsumerState<SpreadSelectionPage> {
  SpreadType _selectedSpread = SpreadType.threeCard;
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ritualState = ref.watch(tarotRitualProvider);

    ref.listen<TarotRitualState>(tarotRitualProvider, (prev, next) {
      if (next.session != null && prev?.session == null) {
        context.pushReplacementNamed(
          'tarotRitual',
          pathParameters: {'sessionId': next.session!.id},
        );
      }
      if (next.error != null && prev?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tarotSelectSpread),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Question input
                  TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: l10n.tarotEnterQuestion,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.help_outline),
                    ),
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),

                  // Spread type grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _SpreadTypeCard(
                        spread: SpreadType.single,
                        title: l10n.tarotSpreadSingle,
                        description: l10n.tarotSpreadSingleDesc,
                        icon: Icons.style,
                        isSelected: _selectedSpread == SpreadType.single,
                        onTap: () =>
                            setState(() => _selectedSpread = SpreadType.single),
                      ),
                      _SpreadTypeCard(
                        spread: SpreadType.threeCard,
                        title: l10n.tarotSpreadThreeCard,
                        description: l10n.tarotSpreadThreeCardDesc,
                        icon: Icons.view_column,
                        isSelected: _selectedSpread == SpreadType.threeCard,
                        onTap: () => setState(
                            () => _selectedSpread = SpreadType.threeCard),
                      ),
                      _SpreadTypeCard(
                        spread: SpreadType.loveSpread,
                        title: l10n.tarotSpreadLove,
                        description: l10n.tarotSpreadLoveDesc,
                        icon: Icons.favorite,
                        isSelected: _selectedSpread == SpreadType.loveSpread,
                        onTap: () => setState(
                            () => _selectedSpread = SpreadType.loveSpread),
                      ),
                      _SpreadTypeCard(
                        spread: SpreadType.celticCross,
                        title: l10n.tarotSpreadCelticCross,
                        description: l10n.tarotSpreadCelticCrossDesc,
                        icon: Icons.grid_view,
                        isSelected: _selectedSpread == SpreadType.celticCross,
                        onTap: () => setState(
                            () => _selectedSpread = SpreadType.celticCross),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: ritualState.isLoading ? null : _startRitual,
                  child: ritualState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.tarotRitualTitle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startRitual() {
    ref.read(tarotRitualProvider.notifier).createSession(
          conversationId: widget.conversationId,
          spreadType: _selectedSpread.value,
          question: _questionController.text.trim(),
        );
  }
}

class _SpreadTypeCard extends StatelessWidget {
  final SpreadType spread;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpreadTypeCard({
    required this.spread,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A1A7A), Color(0xFF2D1B69)],
                )
              : null,
          color: isSelected ? null : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A1A7A).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Colors.white70
                      : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${spread.cardCount} cards',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
