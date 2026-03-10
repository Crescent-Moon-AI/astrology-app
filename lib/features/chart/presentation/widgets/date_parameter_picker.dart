import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/cosmic_colors.dart';

/// Date picker row for transit/progression/lunar return parameters.
class DateParameterPicker extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final String? label;

  const DateParameterPicker({
    super.key,
    required this.date,
    required this.onDateChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final dateFormat = isZh
        ? DateFormat('yyyy年M月d日')
        : DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              dateFormat.format(date),
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_calendar,
              size: 20,
              color: CosmicColors.primaryLight,
            ),
            onPressed: () => _showPicker(context),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              onPrimary: CosmicColors.textPrimary,
              surface: CosmicColors.backgroundDeep,
              onSurface: CosmicColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: CosmicColors.backgroundDeep,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }
}
