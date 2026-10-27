import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/diwaniya.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onFavorite,
    required this.onExplore,
    required this.onOpenDiwaniya,
  });

  final Set<String> favorites;
  final ValueChanged<String> onFavorite;
  final VoidCallback onExplore;
  final ValueChanged<Diwaniya> onOpenDiwaniya;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String _quickFilter = 'الأقرب';

  List<Diwaniya> get _visibleDiwaniyas {
    final query = _query.trim();
    final results = mockDiwaniyas
        .where(
          (item) => item.name.contains(query) || item.location.contains(query),
        )
        .toList();
    if (_quickFilter == 'مفتوحة الآن') {
      results.removeWhere((item) => !item.isOpenNow);
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_quickFilter == 'الأعلى تقييماً') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('home-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  const Expanded(child: BrandMark()),
                  IconButton(
                    tooltip: 'الإشعارات',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('لا توجد إشعارات جديدة')),
                    ),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 5,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.sand,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'الرياض',
                        style: TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.brown,
                        size: 19,
                      ),
                    ],
                  ),
                  const Text(
                    'اكتشف الديوانيات من حولك',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.brown, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SearchField(
                key: const ValueKey('home-search'),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 13),
              SizedBox(
                height: 39,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['الأقرب', 'الأعلى تقييماً', 'مفتوحة الآن']
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: _QuickFilterChip(
                            label: label,
                            selected: _quickFilter == label,
                            onTap: () => setState(() => _quickFilter = label),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 26),
              SectionTitle(
                title: 'الديوانيات القريبة',
                actionLabel: 'عرض الكل',
                onAction: widget.onExplore,
              ),
              const SizedBox(height: 8),
              if (_visibleDiwaniyas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: EmptyState(
                    title: 'ما لقينا ديوانية بهالاسم',
                    message: 'جرّب البحث باسم حي أو نشاط.',
                  ),
                )
              else
                ..._visibleDiwaniyas.map(
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
            ]),
          ),
        ),
      ],
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: AppColors.white,
      selectedColor: AppColors.green,
      side: BorderSide(color: selected ? AppColors.green : AppColors.border),
      labelStyle: TextStyle(
        color: selected ? AppColors.ivory : AppColors.charcoal,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      visualDensity: VisualDensity.compact,
    );
  }
}
