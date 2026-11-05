/// Visitors from one country in a period.
class CountryStat {
  const CountryStat({
    required this.code,
    required this.name,
    required this.visitors,
    required this.located,
  });

  final String code;
  final String name;
  final int visitors;

  /// How many of the visitors have a known place on the map.
  final int located;

  /// Visitors from this country with no place beyond the country itself.
  int get unlocated => visitors - located;
}

/// Visitors from one place, as a point on the map.
class PlaceStat {
  const PlaceStat({
    required this.city,
    required this.region,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.visitors,
  });

  final String city;
  final String region;
  final String countryCode;
  final double latitude;
  final double longitude;
  final int visitors;
}

/// Where the visitors of a period come from.
class VisitorPlaces {
  const VisitorPlaces({
    required this.countries,
    required this.places,
    required this.unknown,
  });

  static const empty = VisitorPlaces(countries: [], places: [], unknown: 0);

  final List<CountryStat> countries;
  final List<PlaceStat> places;

  /// Visitors whose country could not be found out.
  final int unknown;

  /// All visitors counted, those with and without a known country.
  int get total =>
      unknown + countries.fold(0, (sum, country) => sum + country.visitors);

  /// True when no visitor has a known country.
  bool get hasNone => countries.isEmpty;
}

/// A visitor's approximate position, as found from their connection.
class VisitorLocation {
  const VisitorLocation({
    required this.countryCode,
    required this.country,
    this.region = '',
    this.city = '',
    this.latitude,
    this.longitude,
  });

  final String countryCode;
  final String country;
  final String region;
  final String city;
  final double? latitude;
  final double? longitude;
}
