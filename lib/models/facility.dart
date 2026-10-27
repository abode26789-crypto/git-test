import 'package:flutter/material.dart';

class Facility {
  const Facility({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

const availableFacilities = [
  Facility(name: 'بلايستيشن', icon: Icons.sports_esports_outlined),
  Facility(name: 'طاولة بلوت', icon: Icons.style_outlined),
  Facility(name: 'غرف خاصة', icon: Icons.meeting_room_outlined),
  Facility(name: 'شاشة مباريات', icon: Icons.tv_outlined),
  Facility(name: 'بلياردو', icon: Icons.circle_outlined),
  Facility(name: 'قهوة وضيافة', icon: Icons.coffee_outlined),
  Facility(name: 'مواقف', icon: Icons.local_parking_outlined),
  Facility(name: 'تكييف', icon: Icons.ac_unit_outlined),
  Facility(name: 'مجلس عام', icon: Icons.groups_outlined),
  Facility(name: 'مكان للتدخين', icon: Icons.air_outlined),
  Facility(name: 'ألعاب', icon: Icons.toys_outlined),
  Facility(name: 'واي فاي', icon: Icons.wifi_rounded),
];

Facility facilityByName(String name) => availableFacilities.firstWhere(
  (facility) => facility.name == name,
  orElse: () => Facility(name: name, icon: Icons.check_circle_outline),
);
