import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// Segmented selector for switching between chart sub-types
/// (e.g., Secondary Progressions / Solar Arc).
class ChartTypeSelector extends StatelessWidget {
  final List<({String label, bool selected})> options;
  final ValueChanged<int> onSelected;

  const ChartTypeSelector({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final option = options[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: option.selected
                      ? CosmicColors.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: option.selected
                      ? Border.all(
                          color: CosmicColors.primary.withValues(alpha: 0.6),
                        )
                      : null,
                ),
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: option.selected
                        ? CosmicColors.textPrimary
                        : CosmicColors.textSecondary,
                    fontSize: 13,
                    fontWeight:
                        option.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
