import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/message.dart';
import '../../domain/utils/section_parser.dart';

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
  Set<int> _expandedSections = {};
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
    _sections = parseSections(text, metadata: widget.block.metadata?.sections);
    for (var i = 0; i < _sections.length; i++) {
      _sectionKeys.putIfAbsent(i, () => GlobalKey());
    }
    // Expand all sections by default
    _expandedSections = Set<int>.from(
      List.generate(_sections.length, (i) => i),
    );
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
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
