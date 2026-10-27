import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/booking_draft.dart';
import '../models/session.dart';
import '../widgets/app_widgets.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/session_table.dart';
import 'booking_summary_screen.dart';

class SessionFloorPlanScreen extends StatefulWidget {
  const SessionFloorPlanScreen({
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
  State<SessionFloorPlanScreen> createState() => _SessionFloorPlanScreenState();
}

class _SessionFloorPlanScreenState extends State<SessionFloorPlanScreen> {
  Session? _selectedSession;

  Color _statusColor(SessionStatus status) => switch (status) {
    SessionStatus.available => AppColors.green,
    SessionStatus.limited => AppColors.sand,
    SessionStatus.reserved => AppColors.brown,
  };

  bool _matchesRequest(Session session) {
    if (session.capacity < widget.draft.peopleCount ||
        session.status == SessionStatus.reserved) {
      return false;
    }
    if (widget.draft.needsPrivateRoom && session.type != 'private') {
      return false;
    }
    if (widget.draft.needsPlayStation &&
        session.type != 'playstation' &&
        !session.availableFacilities.contains('بلايستيشن')) {
      return false;
    }
    return true;
  }

  Future<void> _showSession(Session session) async {
    final selectable = _matchesRequest(session);
    final selected = await showModalBottomSheet<Session>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.ivory,
      builder: (context) => _SessionSheet(
        session: session,
        statusColor: _statusColor(session.status),
        selectable: selectable,
        peopleCount: widget.draft.peopleCount,
      ),
    );
    if (selected != null && mounted) {
      setState(() => _selectedSession = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = widget.draft.diwaniya.sessions;
    return Scaffold(
      appBar: AppBar(title: const Text('اختر جلستك')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
              children: [
                const BookingStepIndicator(step: 1),
                const SizedBox(height: 20),
                Text(
                  'اختر مكان جلستك',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget.draft.peopleCount} أشخاص · ${widget.draft.durationHours} ساعات',
                  style: const TextStyle(color: AppColors.brown),
                ),
                const SizedBox(height: 15),
                const _FloorLegend(),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final floorWidth = constraints.maxWidth.clamp(280.0, 620.0);
                    return Center(
                      child: SizedBox(
                        width: floorWidth,
                        child: AspectRatio(
                          aspectRatio: 0.94,
                          child: _FloorCanvas(
                            sessions: sessions,
                            selected: _selectedSession,
                            matchesRequest: _matchesRequest,
                            statusColor: _statusColor,
                            onTap: _showSession,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'اختر مساحة مناسبة لمجموعتك',
                    style: TextStyle(color: AppColors.brown, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: PrimaryButton(
              key: const ValueKey('floor-next'),
              label: 'متابعة إلى التأكيد',
              icon: Icons.arrow_back_rounded,
              onPressed: _selectedSession == null
                  ? null
                  : () {
                      widget.draft.session = _selectedSession;
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => BookingSummaryScreen(
                            draft: widget.draft,
                            onReturnHome: widget.onReturnHome,
                            onViewBookings: widget.onViewBookings,
                            onBookingConfirmed: widget.onBookingConfirmed,
                          ),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _FloorLegend extends StatelessWidget {
  const _FloorLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 13,
      runSpacing: 7,
      alignment: WrapAlignment.center,
      children: const [
        _LegendItem(color: AppColors.green, label: 'متاحة'),
        _LegendItem(color: AppColors.sand, label: 'متبقي قليل'),
        _LegendItem(color: AppColors.brown, label: 'محجوزة'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.brown),
        ),
      ],
    );
  }
}

class _FloorCanvas extends StatelessWidget {
  const _FloorCanvas({
    required this.sessions,
    required this.selected,
    required this.matchesRequest,
    required this.statusColor,
    required this.onTap,
  });

  final List<Session> sessions;
  final Session? selected;
  final bool Function(Session) matchesRequest;
  final Color Function(SessionStatus) statusColor;
  final ValueChanged<Session> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.sand, width: 2),
      ),
      margin: const EdgeInsets.all(3),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              top: 0,
              left: constraints.maxWidth * 0.37,
              width: constraints.maxWidth * 0.26,
              child: Container(
                height: 23,
                decoration: const BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'المدخل',
                    style: TextStyle(fontSize: 9, color: AppColors.brown),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              height: 37,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.sand.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'منطقة الضيافة  ·  قهوة عربية',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            ...sessions.map(
              (session) => SessionTable(
                session: session,
                floorSize: constraints.biggest,
                statusColor: statusColor(session.status),
                suitable: matchesRequest(session),
                selected: selected?.id == session.id,
                onTap: () => onTap(session),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionSheet extends StatelessWidget {
  const _SessionSheet({
    required this.session,
    required this.statusColor,
    required this.selectable,
    required this.peopleCount,
  });

  final Session session;
  final Color statusColor;
  final bool selectable;
  final int peopleCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.78,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width - 112,
                      ),
                      child: Text(
                        session.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'إغلاق',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${session.type == 'private' ? 'غرفة خاصة' : 'جلسة'} · سعة ${session.capacity} أشخاص',
                  style: const TextStyle(color: AppColors.brown),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 10, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          session.statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (session.price != null)
                      Text(
                        '${session.price!.toStringAsFixed(0)} ر.س / ساعة',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
                if (session.availableFacilities.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'المرافق',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: session.availableFacilities
                        .map(
                          (name) => Chip(
                            label: Text(
                              name,
                              style: const TextStyle(fontSize: 11),
                            ),
                            visualDensity: VisualDensity.compact,
                            side: BorderSide.none,
                            backgroundColor: AppColors.white,
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (!selectable) ...[
                  const SizedBox(height: 10),
                  Text(
                    session.status == SessionStatus.reserved
                        ? 'هذه الجلسة محجوزة'
                        : session.capacity < peopleCount
                        ? 'سعة الجلسة أقل من عدد الأشخاص'
                        : 'الجلسة لا تطابق اختياراتك',
                    style: const TextStyle(
                      color: AppColors.brown,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 15),
                PrimaryButton(
                  label: 'اختيار الجلسة',
                  icon: Icons.check_rounded,
                  onPressed: selectable
                      ? () => Navigator.of(context).pop(session)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
