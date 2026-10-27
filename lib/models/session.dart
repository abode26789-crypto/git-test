enum SessionStatus { available, limited, reserved }

class Session {
  const Session({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.size,
    required this.availableFacilities,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.price,
  });

  final String id;
  final String name;
  final String type;
  final int capacity;
  final SessionStatus status;
  final String size;
  final List<String> availableFacilities;
  final double x;
  final double y;
  final double width;
  final double height;
  final double? price;

  String get statusLabel => switch (status) {
    SessionStatus.available => 'متاحة',
    SessionStatus.limited => 'متبقي قليل',
    SessionStatus.reserved => 'محجوزة',
  };
}
