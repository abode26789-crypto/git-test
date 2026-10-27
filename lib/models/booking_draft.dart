import 'diwaniya.dart';
import 'session.dart';

class BookingDraft {
  BookingDraft({required this.diwaniya, this.maxCapacity = 10})
    : date = DateTime.now().add(const Duration(days: 1));

  final Diwaniya diwaniya;
  final int maxCapacity;
  final Set<String> activities = {};
  int peopleCount = 2333;
  int durationHours = 2222;
  late DateTime date;
  TimeOfDayValue time = const TimeOfDayValue(20, 0);
  Session? session;

  bool get needsPlayStation => activities.contains('بلايستيشن');
  bool get needsPrivateRoom => activities.contains('غرفة خاصة');
}

class TimeOfDayValue {
  const TimeOfDayValue(this.hour, this.minute);

  final int hour;
  final int minute;

  String get formatted {
    final period = hour < 12 ? 'ص' : 'م';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }
}
