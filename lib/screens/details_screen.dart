import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/booking_draft.dart';
import '../models/diwaniya.dart';
import '../models/facility.dart';
import '../widgets/app_widgets.dart';
import 'booking_preferences_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.diwaniya,
    required this.isFavorite,
    required this.onFavorite,
    required this.onReturnHome,
    required this.onViewBookings,
    required this.onBookingConfirmed,
  });

  final Diwaniya diwaniya;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onReturnHome;
  final ValueChanged<BookingDraft> onViewBookings;
  final ValueChanged<BookingDraft> onBookingConfirmed;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool _isFavorite;
  int _selectedSection = 0;
  final _overviewKey = GlobalKey();
  final _facilitiesKey = GlobalKey();
  final _atmosphereKey = GlobalKey();
  final _reviewsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _scrollToSection(int index, GlobalKey key) {
    setState(() => _selectedSection = index);
    final sectionContext = key.currentContext;
    if (sectionContext != null) {
      Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final diwaniya = widget.diwaniya;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تفاصيل الديوانية',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'إزالة من المحفوظات' : 'حفظ الديوانية',
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              widget.onFavorite();
            },
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
          IconButton(
            tooltip: 'مشاركة',
            onPressed: () => _showMessage(context, 'المشاركة غير متاحة حالياً'),
            icon: const Icon(Icons.ios_share_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 28),
        children: [
          SizedBox(
            height: 238,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: DiwaniyaImage(imageUrl: diwaniya.imageUrl),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            diwaniya.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          RatingWidget(
            rating: diwaniya.rating,
            reviewCount: diwaniya.reviewCount,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.green,
                size: 18,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  diwaniya.location,
                  style: const TextStyle(color: AppColors.brown),
                ),
              ),
              Text(
                diwaniya.distanceLabel,
                style: const TextStyle(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailsSectionTabs(
            selectedIndex: _selectedSection,
            onSelected: (index) {
              final keys = [
                _overviewKey,
                _facilitiesKey,
                _atmosphereKey,
                _reviewsKey,
              ];
              _scrollToSection(index, keys[index]);
            },
          ),
          const SizedBox(height: 23),
          _Gallery(diwaniya: diwaniya),
          const SizedBox(height: 24),
          _DetailSection(
            key: _overviewKey,
            title: 'نبذة عن الديوانية',
            child: Text(
              diwaniya.description,
              style: const TextStyle(color: AppColors.brown, height: 1.7),
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            key: _facilitiesKey,
            title: 'المرافق',
            child: Wrap(
              spacing: 9,
              runSpacing: 9,
              children: diwaniya.facilities.map((name) {
                final facility = facilityByName(name);
                return _FacilityTile(facility: facility);
              }).toList(),
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            key: _atmosphereKey,
            title: 'الأجواء والأنشطة',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diwaniya.activities
                  .map((activity) => _ActivityTag(label: activity))
                  .toList(),
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            title: 'نوع الديوانية',
            child: _InfoPanel(
              icon: Icons.privacy_tip_outlined,
              title: diwaniya.type,
              subtitle: diwaniya.facilities.contains('غرف خاصة')
                  ? 'غرف خاصة متوفرة'
                  : 'مجلس للضيافة واللقاءات',
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            title: 'أوقات التجمع',
            child: _InfoPanel(
              icon: Icons.schedule_rounded,
              title: 'يوميًا',
              subtitle: '${diwaniya.openingTime} - ${diwaniya.closingTime}',
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            title: 'الموقع',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.placeholder,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.green,
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diwaniya.location,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          diwaniya.distanceLabel,
                          style: const TextStyle(
                            color: AppColors.brown,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _showMessage(context, 'سيتم فتح الخرائط لاحقاً'),
                    child: const Text('الخرائط'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _ReviewsSection(key: _reviewsKey, diwaniya: diwaniya),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'احجز جلستك',
            icon: Icons.arrow_back_rounded,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => BookingPreferencesScreen(
                  diwaniya: diwaniya,
                  onReturnHome: widget.onReturnHome,
                  onViewBookings: widget.onViewBookings,
                  onBookingConfirmed: widget.onBookingConfirmed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSectionTabs extends StatelessWidget {
  const _DetailsSectionTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _labels = ['نظرة عامة', 'المرافق', 'الأجواء', 'التقييمات'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _labels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return ChoiceChip(
            label: Text(_labels[index]),
            selected: selected,
            onSelected: (_) => onSelected(index),
            showCheckmark: false,
            backgroundColor: AppColors.white,
            selectedColor: AppColors.green,
            side: BorderSide(
              color: selected ? AppColors.green : AppColors.border,
            ),
            labelStyle: TextStyle(
              color: selected ? AppColors.ivory : AppColors.charcoal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.diwaniya});

  final Diwaniya diwaniya;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle(title: 'صور الديوانية'),
        const SizedBox(height: 9),
        GridView.builder(
          itemCount: diwaniya.galleryUrls.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 104,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
          ),
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: DiwaniyaImage(imageUrl: diwaniya.galleryUrls[index]),
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({required this.facility});

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 105),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(facility.icon, color: AppColors.green, size: 21),
          const SizedBox(height: 5),
          Text(
            facility.name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActivityTag extends StatelessWidget {
  const _ActivityTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.brown, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({super.key, required this.diwaniya});

  final Diwaniya diwaniya;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'التقييمات', actionLabel: 'عرض الكل'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diwaniya.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                '★★★★★',
                style: TextStyle(color: AppColors.sand, fontSize: 17),
              ),
              Text(
                'من ${diwaniya.reviewCount} تقييم',
                style: const TextStyle(color: AppColors.brown, fontSize: 12),
              ),
              const Divider(height: 24, color: AppColors.border),
              const _ReviewLine(
                name: 'أحمد السبيعي',
                review: 'ديوانية جميلة وأجواؤها ممتازة.',
              ),
              const SizedBox(height: 12),
              const _ReviewLine(
                name: 'محمد القحطاني',
                review: 'مكان ممتاز لمشاهدة المباريات والبلوت.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.name, required this.review});

  final String name;
  final String review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Text(
              '★★★★★',
              style: TextStyle(color: AppColors.sand, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          review,
          style: const TextStyle(color: AppColors.brown, fontSize: 12),
        ),
      ],
    );
  }
}
