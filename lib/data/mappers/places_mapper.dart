// Project imports:
import '../../domain/geo/country_catalog.dart';
import '../../domain/models/visitor_places.dart';

/// Reads an integer from JSON, defaulting to 0.
int _int(Map<String, dynamic> json, String key) =>
    (json[key] as num?)?.toInt() ?? 0;

/// Builds a [CountryStat] from JSON, naming the country from its code.
CountryStat countryStatFromJson(Map<String, dynamic> json) {
  final code = json['code'] as String;
  final name = json['name'] as String?;
  return CountryStat(
    code: code,
    name: name == null || name.isEmpty ? CountryCatalog.nameOf(code) : name,
    visitors: _int(json, 'visitors'),
    located: _int(json, 'located'),
  );
}

/// Builds a [PlaceStat] from JSON.
PlaceStat placeStatFromJson(Map<String, dynamic> json) => PlaceStat(
  city: json['city'] as String? ?? '',
  region: json['region'] as String? ?? '',
  countryCode: json['code'] as String? ?? '',
  latitude: (json['lat'] as num).toDouble(),
  longitude: (json['lng'] as num).toDouble(),
  visitors: _int(json, 'visitors'),
);

/// Builds [VisitorPlaces] from JSON.
VisitorPlaces visitorPlacesFromJson(Map<String, dynamic> json) => VisitorPlaces(
  countries: [
    for (final c in json['countries'] as List)
      countryStatFromJson(Map<String, dynamic>.from(c as Map)),
  ],
  places: [
    for (final p in json['places'] as List)
      placeStatFromJson(Map<String, dynamic>.from(p as Map)),
  ],
  unknown: _int(json, 'unknown'),
);
