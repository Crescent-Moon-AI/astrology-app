import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../shared/theme/cosmic_colors.dart';

/// Main shell with bottom navigation bar.
/// Wraps the 5 main tabs: Home, Insight, Consult (center), Diary, Profile
/// (matching real app layout).
class MainShellPage extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  int _currentIndex = 0;

  static const _tabRoutes = [
    '/home',
    '/insight',
    '/consult', // center tab
    '/diary',
    '/profile',
  ];

  @override
  void didUpdateWidget(MainShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTabIndex();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTabIndex();
  }

  void _syncTabIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i])) {
        if (_currentIndex != i) {
          setState(() => _currentIndex = i);
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _CosmicBottomBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          if (index == 2) {
            // Center "consult" tab navigates to full-screen consult page
            context.push('/consult');
            return;
          }
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
          context.go(_tabRoutes[index]);
        },
        labels: [
          l10n.tabHome,
          l10n.tabInsight,
          l10n.tabConsult,
          l10n.tabDiary,
          l10n.tabProfile,
        ],
      ),
    );
  }
}

class _CosmicBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> labels;

  const _CosmicBottomBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.labels,
  });

  static const _unselectedIcons = [
    Icons.home_outlined,
    Icons.auto_graph_outlined,
    null, // center button — custom widget
    Icons.menu_book_outlined,
    Icons.person_outline,
  ];

  static const _selectedIcons = [
    Icons.home,
    Icons.auto_graph,
    null, // center button — custom widget
    Icons.menu_book,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 64 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: CosmicColors.backgroundDeep.withAlpha(230),
        border: const Border(
          top: BorderSide(color: CosmicColors.borderGlow, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            i == 2 ? _buildCenterTab() : _buildTab(i),
        ],
      ),
    );
  }

  /// Regular tab item.
  Widget _buildTab(int index) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? _selectedIcons[index] : _unselectedIcons[index],
              color: isSelected
                  ? CosmicColors.primaryLight
                  : CosmicColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? CosmicColors.primaryLight
                    : CosmicColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Center elevated "consult" button matching real app.
  Widget _buildCenterTab() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CosmicColors.primary.withAlpha(180),
                    CosmicColors.primaryLight.withAlpha(120),
                  ],
                ),
                border: Border.all(
                  color: CosmicColors.primaryLight.withAlpha(100),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.primary.withAlpha(60),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.question_answer_outlined,
                color: CosmicColors.textPrimary,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              labels[2],
              style: const TextStyle(
                fontSize: 11,
                color: CosmicColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
