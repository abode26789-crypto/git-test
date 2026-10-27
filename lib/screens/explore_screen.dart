import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/diwaniya.dart';
import '../models/facility.dart';
import '../widgets/app_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    required this.favorites,
    required this.onFavorite,
    required this.onOpenDiwaniya,
  });

  final Set<String> favorites;
  final ValueChanged<String> onFavorite;
  final ValueChanged<Diwaniya> onOpenDiwaniya;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Set<String> _selectedFacilities = {};
  String _query = '';
  String _sort = 'الأقرب';
  bool _showResults = false;

  List<Diwaniya> get _results {
    final results = mockDiwaniyas.where((diwaniya) {
      final matchesQuery =
          diwaniya.name.contains(_query.trim()) ||
          diwaniya.location.contains(_query.trim());
      final matchesFacilities = _selectedFacilities.every(
        diwaniya.facilities.contains,
      );
      return matchesQuery && matchesFacilities;
    }).toList();
    if (_sort == 'الأعلى تقييمًا' || _sort == 'الأعلى تقييماً') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == 'مفتوحة الآن') {
      results.removeWhere((item) => !item.isOpenNow);
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else {
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            children: [
              Text(
                _showResults ? 'نتائج البحث' : 'استكشاف',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                _showResults
                    ? '${_results.length} ديوانية تطابق معايير البحث'
                    : 'اعثر على مجلس يناسب جلستك القادمة',
                style: const TextStyle(color: AppColors.brown),
              ),
              const SizedBox(height: 20),
              SearchField(
                onChanged: (value) => setState(() => _query = value),
                onFilterTap: () => setState(() => _showResults = false),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 39,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['الأقرب', 'الأعلى تقييمًا', 'مفتوحة الآن']
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: _sort == label,
                            onSelected: (_) => setState(() => _sort = label),
                            showCheckmark: false,
                            selectedColor: AppColors.green,
                            backgroundColor: AppColors.white,
                            side: BorderSide(
                              color: _sort == label
                                  ? AppColors.green
                                  : AppColors.border,
                            ),
                            labelStyle: TextStyle(
                              color: _sort == label
                                  ? AppColors.ivory
                                  : AppColors.charcoal,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              if (!_showResults) ...[
                const SizedBox(height: 25),
                const SectionTitle(title: 'اختر المرافق'),
                const SizedBox(height: 12),
                GridView.builder(
                  itemCount: availableFacilities.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 53,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final facility = availableFacilities[index];
                    final selected = _selectedFacilities.contains(
                      facility.name,
                    );
                    return FacilityChip(
                      facility: facility,
                      selected: selected,
                      showIcon: true,
                      onTap: () => setState(() {
                        if (selected) {
                          _selectedFacilities.remove(facility.name);
                        } else {
                          _selectedFacilities.add(facility.name);
                        }
                      }),
                    );
                  },
                ),
              ] else ...[
                const SizedBox(height: 18),
                if (_results.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: EmptyState(
                      title: 'ما لقينا ديوانية بهالاسم',
                      message: 'جرّب البحث باسم حي أو نشاط.',
                    ),
                  )
                else
                  ..._results.map(
                    (diwaniya) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DiwaniyaCard(
                        diwaniya: diwaniya,
                        isFavorite: widget.favorites.contains(diwaniya.id),
                        onFavorite: () => widget.onFavorite(diwaniya.id),
                        onTap: () => widget.onOpenDiwaniya(diwaniya),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        if (!_showResults)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: PrimaryButton(
              label: 'عرض النتائج (${_results.length})',
              icon: Icons.arrow_back_rounded,
              onPressed: () => setState(() => _showResults = true),
            ),
          ),
      ],
    );
  }
}
