import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import '../../domain/models/birth_data.dart';
import '../../domain/models/chart_request.dart';
import '../../domain/models/chart_result.dart';
import '../providers/chart_providers.dart';
import '../widgets/cross_aspect_table.dart';
import '../widgets/house_overlay_table.dart';
import '../widgets/no_birth_data_prompt.dart';
import '../widgets/person_selector.dart';
import 'package:astrology_app/shared/widgets/breathing_loader.dart';
import 'package:astrology_app/features/settings/presentation/providers/profile_providers.dart';

class SynastryPage extends ConsumerStatefulWidget {
  const SynastryPage({super.key});

  @override
  ConsumerState<SynastryPage> createState() => _SynastryPageState();
}

class _SynastryPageState extends ConsumerState<SynastryPage> {
  BirthData? _person2;
  SynastryChartResult? _result;
  bool _isLoading = false;
  String? _error;

  Future<void> _calculate(BirthData person1) async {
    if (_person2 == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(chartCalculationServiceProvider);
      final result = await service.calculate(
        SynastryRequest(person1: person1, person2: _person2!),
      );
      if (result is SynastryChartResult) {
        setState(() => _result = result);
      } else {
        setState(() => _error = 'engine_unavailable');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final birthAsync = ref.watch(currentBirthDataProvider);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: AppBar(
        backgroundColor: CosmicColors.background,
        title: Text(
          l10n.chartSynastry,
          style: const TextStyle(color: CosmicColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      body: birthAsync.when(
        loading: () => const Center(child: BreathingLoader()),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: CosmicColors.textTertiary,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.errorLoadFailed,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => ref.invalidate(userProfileProvider),
                  child: Text(
                    l10n.retry,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (birth) => birth == null
            ? const NoBirthDataPrompt()
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _PersonCard(
                    label: l10n.chartPerson1,
                    name: birth.name.isEmpty ? l10n.chartMe : birth.name,
                    subtitle: '${birth.birthDate} ${birth.birthTime}',
                  ),
                  const SizedBox(height: 12),
                  PersonSelector(
                    label: l10n.chartPerson2,
                    person: _person2,
                    onPersonChanged: (p) => setState(() => _person2 = p),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CosmicColors.primary,
                        foregroundColor: CosmicColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _person2 == null || _isLoading
                          ? null
                          : () => _calculate(birth),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CosmicColors.textPrimary,
                              ),
                            )
                          : Text(l10n.chartCalculate),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: CosmicColors.error),
                    ),
                  ],
                  if (_result != null) ...[
                    const SizedBox(height: 20),
                    _SynastryResult(result: _result!),
                  ],
                ],
              ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final String label;
  final String name;
  final String subtitle;

  const _PersonCard({
    required this.label,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SynastryResult extends StatelessWidget {
  final SynastryChartResult result;
  const _SynastryResult({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chartCrossAspects,
          style: const TextStyle(
            color: CosmicColors.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        CrossAspectTable(
          aspects: result.crossAspects,
          label1: result.person1.name,
          label2: result.person2.name,
        ),
        const SizedBox(height: 16),
        Text(
          '${result.person1.name} ${isZh ? "行星落入" : "planets in"} ${result.person2.name} ${isZh ? "宫位" : "houses"}',
          style: const TextStyle(
            color: CosmicColors.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        HouseOverlayTable(
          overlays: result.houseOverlays.person1InPerson2Houses,
          personName: result.person1.name,
        ),
        const SizedBox(height: 16),
        Text(
          '${result.person2.name} ${isZh ? "行星落入" : "planets in"} ${result.person1.name} ${isZh ? "宫位" : "houses"}',
          style: const TextStyle(
            color: CosmicColors.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        HouseOverlayTable(
          overlays: result.houseOverlays.person2InPerson1Houses,
          personName: result.person2.name,
        ),
      ],
    );
  }
}
