import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  GooglePlacesService({String? apiKey, http.Client? client})
    : _apiKey = apiKey ?? const String.fromEnvironment('GOOGLE_PLACES_API_KEY'),
      _client = client ?? http.Client();

  static const _baseUrl = 'https://places.googleapis.com/v1';
  final String _apiKey;
  final http.Client _client;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<GooglePlaceDetails?> getPlaceDetails(String placeId) async {
    if (!isConfigured) return null;

    final uri = Uri.parse('$_baseUrl/places/${Uri.encodeComponent(placeId)}');
    final response = await _client.get(
      uri,
      headers: {
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': 'id,displayName,formattedAddress,photos',
      },
    );
    if (response.statusCode != 200) {
      throw GooglePlacesException(response.statusCode, response.body);
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final displayName = json['displayName'] as Map<String, dynamic>?;
    final photos = (json['photos'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(GooglePlacePhoto.fromJson)
        .toList();

    return GooglePlaceDetails(
      placeId: json['id'] as String? ?? placeId,
      name: displayName?['text'] as String? ?? '',
      address: json['formattedAddress'] as String? ?? '',
      photos: photos,
    );
  }

  Uri? getPhotoUri(String photoResourceName, {int maxWidthPx = 1200}) {
    if (!isConfigured || photoResourceName.isEmpty) return null;
    return Uri.parse(
      '$_baseUrl/$photoResourceName/media',
    ).replace(queryParameters: {'maxWidthPx': '$maxWidthPx', 'key': _apiKey});
  }

  Future<Uint8List?> getPhotoBytes(
    String photoResourceName, {
    int maxWidthPx = 1200,
  }) async {
    final uri = getPhotoUri(photoResourceName, maxWidthPx: maxWidthPx);
    if (uri == null) return null;
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw GooglePlacesException(
        response.statusCode,
        'Unable to load place photo',
      );
    }
    return response.bodyBytes;
  }

  Uri getGoogleMapsUri({required String placeId, String? query}) {
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': query?.isNotEmpty == true ? query! : placeId,
      'query_place_id': placeId,
    });
  }

  @visibleForTesting
  void close() => _client.close();
}

class GooglePlaceDetails {
  const GooglePlaceDetails({
    required this.placeId,
    required this.name,
    required this.address,
    required this.photos,
  });

  final String placeId;
  final String name;
  final String address;
  final List<GooglePlacePhoto> photos;
}

class GooglePlacePhoto {
  const GooglePlacePhoto({required this.name, this.widthPx, this.heightPx});

  final String name;
  final int? widthPx;
  final int? heightPx;

  factory GooglePlacePhoto.fromJson(Map<String, dynamic> json) {
    return GooglePlacePhoto(
      name: json['name'] as String? ?? '',
      widthPx: json['widthPx'] as int?,
      heightPx: json['heightPx'] as int?,
    );
  }
}

class GooglePlacesException implements Exception {
  const GooglePlacesException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'Google Places request failed ($statusCode): $message';
}
