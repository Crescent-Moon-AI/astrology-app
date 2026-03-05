import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import '../../domain/models/birth_data.dart';

class PersonSelector extends StatefulWidget {
  final String label;
  final BirthData? person;
  final ValueChanged<BirthData?> onPersonChanged;

  const PersonSelector({
    super.key,
    required this.label,
    this.person,
    required this.onPersonChanged,
  });

  @override
  State<PersonSelector> createState() => _PersonSelectorState();
}

class _PersonSelectorState extends State<PersonSelector> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _updatePerson() {
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());

    if (date.isEmpty || time.isEmpty || lat == null || lng == null) {
      widget.onPersonChanged(null);
      return;
    }

    widget.onPersonChanged(BirthData(
      name: _nameController.text.trim(),
      birthDate: date,
      birthTime: time,
      latitude: lat,
      longitude: lng,
      timezone: 8.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          Text(widget.label,
              style: const TextStyle(
                  color: CosmicColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          _field(_nameController, l10n.chartPersonName, ''),
          const SizedBox(height: 8),
          _field(_dateController, l10n.chartBirthDate, 'YYYY-MM-DD'),
          const SizedBox(height: 8),
          _field(_timeController, l10n.chartBirthTime, 'HH:MM'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _field(_latController, l10n.chartLatitude, '31.23')),
              const SizedBox(width: 8),
              Expanded(
                  child: _field(_lngController, l10n.chartLongitude, '121.47')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      onChanged: (_) => _updatePerson(),
      style: const TextStyle(color: CosmicColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: CosmicColors.textTertiary),
        hintText: hint,
        hintStyle: const TextStyle(color: CosmicColors.textTertiary),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CosmicColors.borderGlow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CosmicColors.primary),
        ),
      ),
    );
  }
}
