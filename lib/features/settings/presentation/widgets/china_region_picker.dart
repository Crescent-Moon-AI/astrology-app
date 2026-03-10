import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../shared/data/china_regions.dart';

/// Result from the China region picker.
class RegionPickerResult {
  final String province;
  final String city;
  final String district;

  const RegionPickerResult({
    required this.province,
    required this.city,
    required this.district,
  });

  /// Formatted display string, e.g. "山东省 - 济宁市 - 邹城市"
  String get displayName => '$province - $city - $district';
}

/// Shows a bottom-sheet 3-column CupertinoPicker for Province → City → District.
/// Returns null if the user taps "取消".
Future<RegionPickerResult?> showChinaRegionPicker(
  BuildContext context, {
  String? initialProvince,
  String? initialCity,
  String? initialDistrict,
}) {
  return showModalBottomSheet<RegionPickerResult>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _ChinaRegionPickerBody(
      initialProvince: initialProvince,
      initialCity: initialCity,
      initialDistrict: initialDistrict,
    ),
  );
}

class _ChinaRegionPickerBody extends StatefulWidget {
  final String? initialProvince;
  final String? initialCity;
  final String? initialDistrict;

  const _ChinaRegionPickerBody({
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
  });

  @override
  State<_ChinaRegionPickerBody> createState() => _ChinaRegionPickerBodyState();
}

class _ChinaRegionPickerBodyState extends State<_ChinaRegionPickerBody> {
  late List<String> _provinces;
  late List<String> _cities;
  late List<String> _districts;

  late FixedExtentScrollController _provinceController;
  late FixedExtentScrollController _cityController;
  late FixedExtentScrollController _districtController;

  int _selectedProvinceIndex = 0;
  int _selectedCityIndex = 0;
  int _selectedDistrictIndex = 0;

  @override
  void initState() {
    super.initState();
    _provinces = chinaRegions.keys.toList();

    // Find initial province index
    if (widget.initialProvince != null) {
      final idx = _provinces.indexOf(widget.initialProvince!);
      if (idx >= 0) _selectedProvinceIndex = idx;
    }

    _cities = _citiesForProvince(_selectedProvinceIndex);

    // Find initial city index
    if (widget.initialCity != null) {
      final idx = _cities.indexOf(widget.initialCity!);
      if (idx >= 0) _selectedCityIndex = idx;
    }

    _districts = _districtsForCity(_selectedProvinceIndex, _selectedCityIndex);

    // Find initial district index
    if (widget.initialDistrict != null) {
      final idx = _districts.indexOf(widget.initialDistrict!);
      if (idx >= 0) _selectedDistrictIndex = idx;
    }

    _provinceController = FixedExtentScrollController(
      initialItem: _selectedProvinceIndex,
    );
    _cityController = FixedExtentScrollController(
      initialItem: _selectedCityIndex,
    );
    _districtController = FixedExtentScrollController(
      initialItem: _selectedDistrictIndex,
    );
  }

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  List<String> _citiesForProvince(int provinceIndex) {
    if (provinceIndex < 0 || provinceIndex >= _provinces.length) return [];
    final province = _provinces[provinceIndex];
    return chinaRegions[province]?.keys.toList() ?? [];
  }

  List<String> _districtsForCity(int provinceIndex, int cityIndex) {
    if (provinceIndex < 0 || provinceIndex >= _provinces.length) return [];
    final province = _provinces[provinceIndex];
    final cities = chinaRegions[province]?.keys.toList() ?? [];
    if (cityIndex < 0 || cityIndex >= cities.length) return [];
    return chinaRegions[province]?[cities[cityIndex]] ?? [];
  }

  void _onProvinceChanged(int index) {
    setState(() {
      _selectedProvinceIndex = index;
      _cities = _citiesForProvince(index);
      _selectedCityIndex = 0;
      _districts = _districtsForCity(index, 0);
      _selectedDistrictIndex = 0;
    });
    _cityController.jumpToItem(0);
    _districtController.jumpToItem(0);
  }

  void _onCityChanged(int index) {
    setState(() {
      _selectedCityIndex = index;
      _districts = _districtsForCity(_selectedProvinceIndex, index);
      _selectedDistrictIndex = 0;
    });
    _districtController.jumpToItem(0);
  }

  void _onDistrictChanged(int index) {
    setState(() {
      _selectedDistrictIndex = index;
    });
  }

  void _confirm() {
    final province = _provinces[_selectedProvinceIndex];
    final city = _cities.isNotEmpty ? _cities[_selectedCityIndex] : province;
    final district = _districts.isNotEmpty
        ? _districts[_selectedDistrictIndex]
        : city;

    Navigator.of(context).pop(
      RegionPickerResult(province: province, city: city, district: district),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          // Top bar: 取消 / 确定
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    isZh ? '取消' : 'Cancel',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _confirm,
                  child: Text(
                    isZh ? '确定' : 'Confirm',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Three linked pickers
          Expanded(
            child: Row(
              children: [
                // Province picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _provinceController,
                    itemExtent: 40,
                    onSelectedItemChanged: _onProvinceChanged,
                    children: _provinces
                        .map(
                          (p) => Center(
                            child: Text(
                              p,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // City picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _cityController,
                    itemExtent: 40,
                    onSelectedItemChanged: _onCityChanged,
                    children: _cities
                        .map(
                          (c) => Center(
                            child: Text(
                              c,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // District picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _districtController,
                    itemExtent: 40,
                    onSelectedItemChanged: _onDistrictChanged,
                    children: _districts
                        .map(
                          (d) => Center(
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
