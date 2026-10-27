import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/booking_draft.dart';
import '../models/diwaniya.dart';
import '../widgets/app_widgets.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    super.key,
    required this.favorites,
    required this.onFavorite,
    required this.onOpenDiwaniya,
  });

  final Set<String> favorites;
  final ValueChanged<String> onFavorite;
  final ValueChanged<Diwaniya> onOpenDiwaniya;

  @override
  Widget build(BuildContext context) {
    final saved = mockDiwaniyas
        .where((diwaniya) => favorites.contains(diwaniya.id))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      children: [
        Text('المحفوظة', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        const Text(
          'ديوانياتك المفضلة في مكان واحد',
          style: TextStyle(color: AppColors.brown),
        ),
        const SizedBox(height: 22),
        if (saved.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 70),
            child: EmptyState(
              title: 'ما حفظت أي ديوانية للحين',
              message: 'اضغط على رمز القلب في أي ديوانية لتجدها هنا.',
            ),
          )
        else
          ...saved.map(
            (diwaniya) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DiwaniyaCard(
                diwaniya: diwaniya,
                isFavorite: true,
                onFavorite: () => onFavorite(diwaniya.id),
                onTap: () => onOpenDiwaniya(diwaniya),
              ),
            ),
          ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.bookingDrafts,
    required this.onOpenBookings,
    required this.onOpenSaved,
    required this.onOpenAddDiwaniya,
    required this.onOpenSettings,
  });

  final List<BookingDraft> bookingDrafts;
  final VoidCallback onOpenBookings;
  final VoidCallback onOpenSaved;
  final VoidCallback onOpenAddDiwaniya;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      children: [
        Text('حسابي', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: AppColors.placeholder,
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.green,
                  size: 28,
                ),
              ),
              SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سعد العتيبي',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'عضو ديوانيات',
                    style: TextStyle(color: AppColors.brown, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ProfileOption(
          icon: Icons.calendar_month_outlined,
          label: 'حجوزاتي',
          onTap: onOpenBookings,
          trailing: bookingDrafts.isEmpty ? null : '${bookingDrafts.length}',
        ),
        _ProfileOption(
          icon: Icons.bookmark_border,
          label: 'الديوانيات المحفوظة',
          onTap: onOpenSaved,
        ),
        _ProfileOption(
          icon: Icons.add_business_outlined,
          label: 'إضافة ديوانية',
          onTap: onOpenAddDiwaniya,
        ),
        _ProfileOption(
          icon: Icons.settings_outlined,
          label: 'الإعدادات',
          onTap: onOpenSettings,
        ),
        _ProfileOption(
          icon: Icons.info_outline,
          label: 'عن ديوانيات',
          onTap: onOpenSettings,
        ),
        _ProfileOption(
          icon: Icons.support_agent_outlined,
          label: 'المساعدة والدعم',
          onTap: onOpenSettings,
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: AppColors.green),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: trailing == null
          ? const Icon(Icons.chevron_left_rounded, color: AppColors.brown)
          : Text(trailing!, style: const TextStyle(color: AppColors.green)),
      onTap: onTap,
    );
  }
}
