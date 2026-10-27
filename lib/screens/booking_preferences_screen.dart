import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/booking_draft.dart';
import '../models/diwaniya.dart';
import '../widgets/app_widgets.dart';
import '../widgets/booking_step_indicator.dart';
import 'session_floor_plan_screen.dart';

class BookingPreferencesScreen extends StatefulWidget {
  const BookingPreferencesScreen({
    super.key,
    required this.diwaniya,
    required this.onReturnHome,
    required this.onViewBookings,
    required this.onBookingConfirmed,
  });

  final Diwaniya diwaniya;
  final VoidCallback onReturnHome;
  final ValueChanged<BookingDraft> onViewBookings;
  final ValueChanged<BookingDraft> onBookingConfirmed;

  @override
  State<BookingPreferencesScreen> createState() =>
      _BookingPreferencesScreenState();
}

class _BookingPreferencesScreenState extends State<BookingPreferencesScreen> {
  static const _activities = [
    ('جلسة عادية', Icons.groups_outlined),
    ('بلايستيشن', Icons.sports_esports_outlined),
    ('طاولة بلوت', Icons.style_outlined),
    ('مشاهدة مباراة', Icons.tv_outlined),
    ('غرفة خاصة', Icons.meeting_room_outlined),
    ('بلياردو', Icons.circle_outlined),
  ];

  late final BookingDraft _draft = BookingDraft(diwaniya: widget.diwaniya);
  int _step = 0;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      helpText: 'اختر يوم الحجز',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );
    if (picked != null) setState(() => _draft.date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _draft.time.hour,
        minute: _draft.time.minute,
      ),
      helpText: 'اختر وقت الحجز',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );
    if (picked != null) {
      setState(() => _draft.time = TimeOfDayValue(picked.hour, picked.minute));
    }
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SessionFloorPlanScreen(
          draft: _draft,
          onReturnHome: widget.onReturnHome,
          onViewBookings: widget.onViewBookings,
          onBookingConfirmed: widget.onBookingConfirmed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'وش تبي تحجز؟',
      'كم شخص؟',
      'كم مدة الحجز؟',
      'متى تبي تحجز؟',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('حجز جلسة')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              children: [
                BookingStepIndicator(step: 0),
                const SizedBox(height: 25),
                Text(
                  titles[_step],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.diwaniya.name,
                  style: const TextStyle(color: AppColors.brown),
                ),
                const SizedBox(height: 22),
                if (_step == 0) _activityChoices(),
                if (_step == 1) _peopleChoice(),
                if (_step == 2) _durationChoices(),
                if (_step == 3) _dateTimeChoices(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: PrimaryButton(
              key: ValueKey('booking-next-$_step'),
              label: _step == 3 ? 'اختيار الجلسة' : 'التالي',
              icon: Icons.arrow_back_rounded,
              onPressed: _next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityChoices() {
    return GridView.builder(
      itemCount: _activities.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 82,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final item = _activities[index];
        final selected = _draft.activities.contains(item.$1);
        return _SelectionTile(
          label: item.$1,
          icon: item.$2,
          selected: selected,
          onTap: () => setState(() {
            if (item.$1 == 'جلسة عادية') {
              _draft.activities
                ..clear()
                ..add(item.$1);
            } else {
              _draft.activities.remove('جلسة عادية');
              if (selected) {
                _draft.activities.remove(item.$1);
              } else {
                _draft.activities.add(item.$1);
              }
            }
          }),
        );
      },
    );
  }

  Widget _peopleChoice() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.groups_2_outlined, color: AppColors.green, size: 34),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StepperButton(
                buttonKey: const ValueKey('people-decrement'),
                icon: Icons.remove,
                enabled: _draft.peopleCount > 1,
                onTap: () => setState(() => _draft.peopleCount--),
              ),
              SizedBox(
                width: 86,
                child: Text(
                  '${_draft.peopleCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StepperButton(
                buttonKey: const ValueKey('people-increment'),
                icon: Icons.add,
                enabled: _draft.peopleCount < _draft.maxCapacity,
                onTap: () => setState(() => _draft.peopleCount++),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'شخص (الحد الأعلى ${_draft.maxCapacity})',
            style: const TextStyle(color: AppColors.brown, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _durationChoices() {
    return Column(
      children: [1, 2, 3, 4].map((hours) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _SelectionTile(
            label: hours == 1 ? 'ساعة واحدة' : '$hours ساعات',
            icon: Icons.schedule_rounded,
            selected: _draft.durationHours == hours,
            onTap: () => setState(() => _draft.durationHours = hours),
          ),
        );
      }).toList(),
    );
  }

  Widget _dateTimeChoices() {
    final dateLabel =
        '${_draft.date.day}/${_draft.date.month}/${_draft.date.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر اليوم', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        _PickerTile(
          key: const ValueKey('booking-date'),
          icon: Icons.calendar_month_outlined,
          label: dateLabel,
          onTap: _pickDate,
        ),
        const SizedBox(height: 20),
        const Text('اختر الوقت', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        _PickerTile(
          key: const ValueKey('booking-time'),
          icon: Icons.access_time_rounded,
          label: _draft.time.formatted,
          onTap: _pickTime,
        ),
      ],
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.green.withValues(alpha: 0.08)
          : AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.green : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.green, size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.buttonKey,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      key: buttonKey,
      onPressed: enabled ? onTap : null,
      style: IconButton.styleFrom(
        foregroundColor: AppColors.green,
        backgroundColor: AppColors.ivory,
        disabledForegroundColor: AppColors.brown.withValues(alpha: 0.4),
      ),
      icon: Icon(icon),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: AppColors.white,
      leading: Icon(icon, color: AppColors.green),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.brown),
    );
  }
}
