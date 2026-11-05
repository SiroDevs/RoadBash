// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/visitor_places.dart';

/// Finds out roughly where the player is, from their connection.
///
/// Only the country, region and city are kept, with a position good to about
/// a city. No address is stored.
@lazySingleton
class GeoSource {
  static final Uri _endpoint = Uri.parse(
    'https://ipwho.is/?fields=success,country,country_code,region,city,latitude,longitude',
  );
  static const Duration _timeout = Duration(seconds: 4);

  /// Returns the visitor's approximate place, or null when it can't be found.
  Future<VisitorLocation?> lookup() async {
    try {
      final response = await http.get(_endpoint).timeout(_timeout);
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final code = json['country_code'] as String?;
      if (json['success'] != true || code == null || code.length != 2) {
        return null;
      }
      return VisitorLocation(
        countryCode: code.toUpperCase(),
        country: json['country'] as String? ?? '',
        region: json['region'] as String? ?? '',
        city: json['city'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
