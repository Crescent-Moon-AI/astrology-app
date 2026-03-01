import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/message.dart';
import '../../domain/utils/section_parser.dart';
import 'section_reveal_button.dart';

class ProgressiveTextBlock extends StatefulWidget {
  final MessageBlock block;
  final ScrollController? scrollController;

  const ProgressiveTextBlock({
    super.key,
    required this.block,
    this.scrollController,
  });

  @override
  State<ProgressiveTextBlock> createState() => _ProgressiveTextBlockState();
}

class _ProgressiveTextBlockState extends State<ProgressiveTextBlock> {
  late List<ParsedSection> _sections;
  final Set<int> _expandedSections = {0}; // First section expanded by default
  final Map<int, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    _parseSections();
  }

  @override
  void didUpdateWidget(ProgressiveTextBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.contentText != oldWidget.block.contentText) {
      _parseSections();
    }
  }

  void _parseSections() {
    final text = widget.block.contentText ?? '';
    _sections = parseSections(
      text,
      metadata: widget.block.metadata?.sections,
    );
    for (var i = 0; i < _sections.length; i++) {
      _sectionKeys.putIfAbsent(i, () => GlobalKey());
    }
  }

  void _expandSection(int index) {
    setState(() {
      _expandedSections.add(index);
      // Auto-expand final section when second-to-last is expanded
      if (index == _sections.length - 2 && _sections.length > 1) {
        _expandedSections.add(_sections.length - 1);
      }
    });
    // Auto-scroll to the newly expanded section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSection(index);
    });
  }

  void _toggleSection(int index) {
    setState(() {
      if (_expandedSections.contains(index)) {
        _expandedSections.remove(index);
      } else {
        _expandedSections.add(index);
      }
    });
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sections.isEmpty) {
      // Fallback: render as plain markdown
      return MarkdownBody(data: widget.block.contentText ?? '');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _sections.length; i++) ...[
          _buildSection(i),
          if (i < _sections.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildSection(int index) {
    final section = _sections[index];
    final isExpanded = _expandedSections.contains(index);
    final isLast = index == _sections.length - 1;
    final showContinue =
        isExpanded && !isLast && !_expandedSections.contains(index + 1);

    return Column(
      key: _sectionKeys[index],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header (tap to toggle)
        InkWell(
          onTap: () => _toggleSection(index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: isExpanded
                        ? CosmicColors.primaryLight
                        : CosmicColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      color: isExpanded
                          ? CosmicColors.textPrimary
                          : CosmicColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Section content with cross-fade animation
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 32, right: 8, bottom: 8),
            child: MarkdownBody(data: section.content),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        // "Continue Reading" button
        if (showContinue)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: SectionRevealButton(
              onPressed: () => _expandSection(index + 1),
            ),
          ),
      ],
    );
  }
}
