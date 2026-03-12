import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

import '../../config/env.dart';
import '../../config/router.dart';
import '../providers/dev_server_provider.dart';
import '../theme/cosmic_colors.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

/// Floating dev tool button — visible on every page in dev/mock mode.
/// Draggable via raw pointer events; tap opens the dev server panel.
/// Uses TextButton for proper hit-testing in Stack overlay.
/// Must be placed as a direct child of a Stack.
class DevToolsFab extends ConsumerStatefulWidget {
  const DevToolsFab({super.key});

  @override
  ConsumerState<DevToolsFab> createState() => _DevToolsFabState();
}

class _DevToolsFabState extends ConsumerState<DevToolsFab> {
  double _left = 12;
  double _bottom = 90;
  bool _sheetOpen = false;

  // Drag tracking via raw pointer events
  double _dragDistance = 0;

  void _onPointerDown(PointerDownEvent e) {
    _dragDistance = 0;
  }

  void _onPointerMove(PointerMoveEvent e) {
    _dragDistance += e.delta.distance;
    if (_dragDistance > 8) {
      // Threshold exceeded — treat as drag
      setState(() {
        _left += e.delta.dx;
        _bottom -= e.delta.dy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppConfig.mode != AppMode.dev && AppConfig.mode != AppMode.mock) {
      return const SizedBox.shrink();
    }

    ref.watch(devServerProvider);
    final host = Uri.tryParse(AppConfig.apiBaseUrl)?.host ?? '';
    final label = host.split('.').first;

    return Positioned(
      left: _left,
      bottom: _bottom,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        child: SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              if (!_sheetOpen && _dragDistance <= 8) {
                _showDevPanel();
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xF0101020),
              foregroundColor: CosmicColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: CosmicColors.primary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.build_outlined, size: 13),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDevPanel() {
    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null) return;

    setState(() => _sheetOpen = true);

    final controller = TextEditingController(text: AppConfig.apiBaseUrl);
    final l10n = AppLocalizations.of(navContext);
    final defaultUrl = AppConfig.initial.apiBaseUrl;

    showModalBottomSheet(
      context: navContext,
      backgroundColor: const Color(0xFF1A1A2E),
      barrierColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          16 + MediaQuery.of(sheetCtx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: CosmicColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.devServerTitle ?? '开发者选项',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n?.devServerLabel ?? '服务器地址',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n?.devServerDefault(defaultUrl) ?? '默认: $defaultUrl',
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: defaultUrl,
                hintStyle: const TextStyle(color: CosmicColors.textTertiary),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xFF0D0D1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: CosmicColors.borderGlow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: CosmicColors.borderGlow),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: CosmicColors.primary),
                ),
              ),
              onSubmitted: (_) => _applyServer(sheetCtx, controller),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _applyServer(sheetCtx, controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CosmicColors.primary,
                  foregroundColor: CosmicColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(l10n?.devServerApply ?? '应用'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ).whenComplete(() {
      controller.dispose();
      if (mounted) setState(() => _sheetOpen = false);
    });
  }

  void _applyServer(BuildContext sheetCtx, TextEditingController controller) {
    final url = controller.text.trim();
    if (url.isEmpty || url == AppConfig.apiBaseUrl) {
      Navigator.pop(sheetCtx);
      return;
    }

    final defaultUrl = AppConfig.initial.apiBaseUrl;
    final overrideUrl = (url == defaultUrl) ? '' : url;
    ref.read(devServerProvider.notifier).setServer(overrideUrl);
    ref.read(authProvider.notifier).logout();

    final navContext = rootNavigatorKey.currentContext;
    final l10n = navContext != null ? AppLocalizations.of(navContext) : null;

    Navigator.pop(sheetCtx);
    if (navContext != null) {
      ScaffoldMessenger.of(navContext).showSnackBar(
        SnackBar(content: Text(l10n?.devServerSwitched ?? '已切换服务器，请重新登录')),
      );
    }
  }
}
