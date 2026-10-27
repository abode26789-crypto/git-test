import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/diwaniya.dart';
import '../models/facility.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 40.0 : 48.0;
    return Row(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Container(
              width: iconSize * 0.42,
              height: iconSize * 0.52,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.sand, width: 2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                  bottom: Radius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ديوانيات',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: compact ? 22 : 27,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: 3),
                const Text(
                  'حيث تبدأ اللمة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'ابحث عن ديوانية أو حي...',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.green),
        suffixIcon: onFilterTap == null
            ? null
            : IconButton(
                tooltip: 'تصفية النتائج',
                onPressed: onFilterTap,
                icon: const Icon(Icons.tune_rounded, color: AppColors.green),
              ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: AppColors.green),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.compact = false,
  });

  final double rating;
  final int? reviewCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.sand, size: 18),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w800,
            fontSize: compact ? 12 : 14,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 5),
          Text(
            '$reviewCount تقييم',
            style: TextStyle(
              color: AppColors.brown,
              fontSize: compact ? 10 : 12,
            ),
          ),
        ],
      ],
    );
  }
}

class FacilityChip extends StatelessWidget {
  const FacilityChip({
    super.key,
    required this.facility,
    this.selected = false,
    this.onTap,
    this.showIcon = false,
  });

  final Facility facility;
  final bool selected;
  final VoidCallback? onTap;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.ivory : AppColors.charcoal;
    return Material(
      color: selected ? AppColors.green : AppColors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? AppColors.green : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                Icon(facility.icon, color: foreground, size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                facility.name,
                style: TextStyle(
                  color: foreground,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 19),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        iconAlignment: IconAlignment.end,
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.ivory,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class DiwaniyaImage extends StatelessWidget {
  const DiwaniyaImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const _ImageFallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _ImageFallback();
      },
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.placeholder,
      child: Center(
        child: Container(
          width: 64,
          height: 76,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.sand, width: 2),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(34),
              bottom: Radius.circular(5),
            ),
          ),
          child: const Icon(Icons.groups_2_outlined, color: AppColors.green),
        ),
      ),
    );
  }
}

class DiwaniyaCard extends StatelessWidget {
  const DiwaniyaCard({
    super.key,
    required this.diwaniya,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final Diwaniya diwaniya;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 116,
                height: 132,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: DiwaniyaImage(imageUrl: diwaniya.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              diwaniya.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: IconButton(
                              tooltip: isFavorite
                                  ? 'إزالة من المحفوظات'
                                  : 'إضافة إلى المحفوظات',
                              padding: EdgeInsets.zero,
                              onPressed: onFavorite,
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFavorite
                                    ? AppColors.green
                                    : AppColors.brown,
                                size: 19,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            diwaniya.distanceLabel,
                            style: const TextStyle(
                              color: AppColors.brown,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.brown,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              diwaniya.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.brown,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RatingWidget(
                            rating: diwaniya.rating,
                            reviewCount: diwaniya.reviewCount,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: diwaniya.facilities.take(3).map((name) {
                          return FacilityChip(facility: facilityByName(name));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (label: 'الرئيسية', icon: Icons.home_outlined),
    (label: 'استكشاف', icon: Icons.explore_outlined),
    (label: 'إضافة', icon: Icons.add),
    (label: 'المحفوظة', icon: Icons.bookmark_border_rounded),
    (label: 'حسابي', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.fromLTRB(6, 7, 6, 5),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = index == selectedIndex;
            if (index == 2) {
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 43,
                        height: 37,
                        decoration: BoxDecoration(
                          color: AppColors.sand,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, color: AppColors.green),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: const TextStyle(
                          color: AppColors.brown,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Expanded(
              child: InkWell(
                onTap: () => onSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: selected ? AppColors.green : AppColors.brown,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      maxLines: 1,
                      style: TextStyle(
                        color: selected ? AppColors.green : AppColors.brown,
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: AppColors.green,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.brown, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
