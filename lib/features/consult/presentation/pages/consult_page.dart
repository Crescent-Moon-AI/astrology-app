import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../widgets/free_consult_tab.dart';
import '../widgets/tarot_consult_tab.dart';
import '../widgets/chart_consult_tab.dart';
import '../widgets/consult_scenario_cards.dart';

class ConsultPage extends StatefulWidget {
  const ConsultPage({super.key});

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (Navigator.of(context).canPop())
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: CosmicColors.textSecondary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (Navigator.of(context).canPop())
                      const SizedBox(width: 8),
                    Text(
                      l10n.consultRoomTitle,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Sub tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: CosmicColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: CosmicColors.primary.withAlpha(77),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0,
                  labelColor: CosmicColors.textPrimary,
                  unselectedLabelColor: CosmicColors.textTertiary,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 14),
                  tabs: [
                    Tab(text: l10n.consultFreeAsk),
                    Tab(text: l10n.consultTarot),
                    Tab(text: l10n.consultChart),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    _ConsultTabContent(child: FreeConsultTab()),
                    _ConsultTabContent(child: TarotConsultTab()),
                    _ConsultTabContent(child: ChartConsultTab()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsultTabContent extends StatelessWidget {
  final Widget child;

  const _ConsultTabContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          child,
          const SizedBox(height: 16),
          const ConsultScenarioCards(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
