import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../l10n/scenario_strings.dart';
import '../providers/scenario_providers.dart';
import '../widgets/scenario_icon_data.dart';

class ScenarioDetailPage extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailPage({
    super.key,
    required this.scenarioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final scenarioAsync = ref.watch(scenarioDetailProvider(scenarioId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: scenarioAsync.when(
          data: (scenario) {
            if (scenario == null) {
              return const Center(child: Text('Scenario not found'));
            }

            final visual = getScenarioVisual(scenario.slug);
            final title = resolveScenarioKey(scenario.title, locale);
            final description =
                resolveScenarioKey(scenario.description, locale);

            return CustomScrollView(
              slivers: [
                // Immersive app bar with gradient
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: CosmicColors.background.withValues(alpha: 0.9),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CosmicColors.textPrimary,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            visual.gradient[0].withValues(alpha: 0.4),
                            visual.gradient[1].withValues(alpha: 0.15),
                            CosmicColors.background,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Large decorative icon
                          Positioned(
                            right: -30,
                            top: 20,
                            child: Icon(
                              visual.icon,
                              size: 180,
                              color: visual.gradient[0].withValues(alpha: 0.08),
                            ),
                          ),
                          // Center emoji
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Text(
                                visual.emoji,
                                style: const TextStyle(fontSize: 72),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        if (scenario.category != null)
                          _CategoryBadge(
                            name: resolveScenarioKey(
                                scenario.category!.name, locale),
                            iconName: scenario.category!.icon,
                          ),

                        const SizedBox(height: 20),

                        // Description in glass card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: CosmicColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: CosmicColors.borderGlow,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                description,
                                style: const TextStyle(
                                  color: CosmicColors.textPrimary,
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Preset questions
                        if (scenario.presetQuestions.isNotEmpty) ...[
                          Row(
                            children: [
                              const Text(
                                '\uD83D\uDCAC', // 💬
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.scenarioPresetQuestions,
                                style: const TextStyle(
                                  color: CosmicColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...scenario.presetQuestions.map((q) {
                            final translated =
                                resolveScenarioKey(q, locale);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _PresetQuestionCard(
                                question: translated,
                                accentColor: visual.gradient[0],
                                onTap: () {
                                  context.pushNamed(
                                    'chat',
                                    queryParameters: {
                                      'scenario_id': scenario.id,
                                      'initial_message': translated,
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                        ],

                        // Disclaimer
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            locale == 'zh'
                                ? '\u2728 AI 生成内容，仅供参考和娱乐'
                                : '\u2728 AI-generated content for reference and entertainment only',
                            style: const TextStyle(
                              color: CosmicColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 80), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: CosmicColors.primary,
            ),
          ),
          error: (error, _) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: CosmicColors.error),
            ),
          ),
        ),
      ),
      // Floating CTA button
      bottomNavigationBar: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) return const SizedBox.shrink();
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  CosmicColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: CosmicColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          'chat',
                          queryParameters: {
                            'scenario_id': scenario.id,
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: CosmicColors.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.scenarioStartConsultation,
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
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String name;
  final String iconName;

  const _CategoryBadge({required this.name, required this.iconName});

  @override
  Widget build(BuildContext context) {
    final visual = getCategoryVisual(iconName);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: visual.accentColor.withValues(alpha: 0.15),
        border: Border.all(
          color: visual.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(visual.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: visual.accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetQuestionCard extends StatelessWidget {
  final String question;
  final Color accentColor;
  final VoidCallback onTap;

  const _PresetQuestionCard({
    required this.question,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CosmicColors.surface,
          border: Border.all(
            color: CosmicColors.borderGlow,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: accentColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: CosmicColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
