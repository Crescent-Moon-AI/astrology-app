import 'package:flutter/material.dart';

class AutoScrollController {
  final ScrollController scrollController;
  bool _isUserScrolledUp = false;
  static const double _bottomThreshold = 50.0;

  AutoScrollController({ScrollController? controller})
      : scrollController = controller ?? ScrollController() {
    scrollController.addListener(_onScroll);
  }

  bool get isAtBottom => !_isUserScrolledUp;

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    _isUserScrolledUp = (maxScroll - currentScroll) > _bottomThreshold;
  }

  void scrollToBottom({
    Duration duration = const Duration(milliseconds: 200),
  }) {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  void scrollToKey(
    GlobalKey key, {
    Duration duration = const Duration(milliseconds: 200),
  }) {
    if (_isUserScrolledUp) return;
    if (key.currentContext == null) return;
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: duration,
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
  }
}
