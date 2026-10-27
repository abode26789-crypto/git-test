import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/booking_draft.dart';
import '../widgets/app_widgets.dart';
import '../widgets/booking_step_indicator.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({
    super.key,
    required this.draft,
    required this.onReturnHome,
    required this.onViewBookings,
    required this.onBookingConfirmed,
  });

  final BookingDraft draft;
  final VoidCallback onReturnHome;
  final ValueChanged<BookingDraft> onViewBookings;
  final ValueChanged<BookingDraft> onBookingConfirmed;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final session = draft.session!;
    final date = '${draft.date.day}/${draft.date.month}/${draft.date.year}';
    final total = (session.price ?? 0) * draft.durationHours;

    if (_confirmed) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.ivory,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'تم تأكيد حجزك',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'جلسة جميلة تبدأ من هنا',
                    style: TextStyle(color: AppColors.brown),
                  ),
                  const SizedBox(height: 24),
                  _ReceiptCard(
                    entries: [
                      ('الديوانية', draft.diwaniya.name),
                      ('الجلسة', session.name),
                      ('التاريخ', date),
                      ('الوقت', draft.time.formatted),
                      ('عدد الأشخاص', '${draft.peopleCount} أشخاص'),
                    ],
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'العودة للرئيسية',
                    icon: Icons.home_outlined,
                    onPressed: widget.onReturnHome,
                  ),
                  const SizedBox(height: 9),
                  TextButton.icon(
                    onPressed: () => widget.onViewBookings(draft),
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('عرض حجوزاتي'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الحجز')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              children: [
                const BookingStepIndicator(step: 2),
                const SizedBox(height: 25),
                Text(
                  'راجع تفاصيل جلستك',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 7),
                const Text(
                  'تأكد من الاختيارات قبل تأكيد الحجز',
                  style: TextStyle(color: AppColors.brown),
                ),
                const SizedBox(height: 20),
                _ReceiptCard(
                  entries: [
                    ('الديوانية', draft.diwaniya.name),
                    ('الجلسة', session.name),
                    (
                      'النشاط',
                      draft.activities.isEmpty
                          ? 'جلسة عادية'
                          : draft.activities.join('، '),
                    ),
                    ('عدد الأشخاص', '${draft.peopleCount} أشخاص'),
                    ('المدة', '${draft.durationHours} ساعات'),
                    ('التاريخ', date),
                    ('الوقت', draft.time.formatted),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'الإجمالي التقديري',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '${total.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'هذا حجز تجريبي محفوظ محلياً، ولا يتم تنفيذ أي عملية دفع.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.brown, fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: PrimaryButton(
              key: const ValueKey('confirm-booking'),
              label: 'تأكيد الحجز',
              icon: Icons.check_rounded,
              onPressed: () {
                widget.onBookingConfirmed(draft);
                setState(() => _confirmed = true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.entries});

  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.$1,
                        style: const TextStyle(color: AppColors.brown),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        entry.$2,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BookingReceiptScreen extends StatelessWidget {
  const BookingReceiptScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final session = draft.session!;
    return Scaffold(
      appBar: AppBar(title: const Text('حجوزاتي')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 42,
            color: AppColors.green,
          ),
          const SizedBox(height: 15),
          Text(
            'حجزك القادم',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          _ReceiptCard(
            entries: [
              ('الديوانية', draft.diwaniya.name),
              ('الجلسة', session.name),
              (
                'التاريخ',
                '${draft.date.day}/${draft.date.month}/${draft.date.year}',
              ),
              ('الوقت', draft.time.formatted),
              ('العدد', '${draft.peopleCount} أشخاص'),
            ],
          ),
        ],
      ),
    );
  }
}
