import 'session.dart';

class Diwaniya {
  const Diwaniya({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.galleryUrls,
    required this.facilities,
    required this.activities,
    required this.type,
    required this.openingTime,
    required this.closingTime,
    required this.description,
    required this.isOpenNow,
    required this.sessions,
  });

  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> galleryUrls;
  final List<String> facilities;
  final List<String> activities;
  final String type;
  final String openingTime;
  final String closingTime;
  final String description;
  final bool isOpenNow;
  final List<Session> sessions;

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} كم';
}
