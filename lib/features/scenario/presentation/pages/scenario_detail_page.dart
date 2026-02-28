import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../providers/scenario_providers.dart';
import '../widgets/preset_question_chip.dart';

class ScenarioDetailPage extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailPage({
    super.key,
    required this.scenarioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scenarioAsync = ref.watch(scenarioDetailProvider(scenarioId));

    return Scaffold(
      body: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) {
            return const Center(child: Text('Scenario not found'));
          }
          return CustomScrollView(
            slivers: [
              // App bar with scenario image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    scenario.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                    child: scenario.iconUrl.isNotEmpty
                        ? Image.network(
                            scenario.iconUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.auto_awesome,
                              size: 64,
                              color: Colors.white54,
                            ),
                          )
                        : const Icon(
                            Icons.auto_awesome,
                            size: 64,
                            color: Colors.white54,
                          ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      if (scenario.category != null)
                        Chip(
                          label: Text(scenario.category!.name),
                          avatar: Icon(
                            _getCategoryIcon(scenario.category!.icon),
                            size: 18,
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Description
                      Text(
                        scenario.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 24),

                      // Preset questions
                      if (scenario.presetQuestions.isNotEmpty) ...[
                        Text(
                          l10n.scenarioPresetQuestions,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: scenario.presetQuestions
                              .map((q) => PresetQuestionChip(
                                    question: q,
                                    onTap: () {
                                      // TODO: Navigate to chat with preset question
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () {
                  // TODO: Create conversation with scenario_id metadata and navigate to chat
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(l10n.scenarioStartConsultation),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
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

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'heart':
        return Icons.favorite;
      case 'briefcase':
        return Icons.work;
      case 'dice':
        return Icons.casino;
      case 'mirror':
        return Icons.self_improvement;
      case 'people':
        return Icons.people;
      default:
        return Icons.auto_awesome;
    }
  }
}
