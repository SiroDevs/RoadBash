// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../domain/geo/country_catalog.dart';
import '../../../../domain/models/visitor_places.dart';
import 'world_mask.dart';

/// Visitors at one position on the map.
class HeatPoint {
  const HeatPoint(this.latitude, this.longitude, this.visitors);

  final double latitude;
  final double longitude;
  final int visitors;
}

/// How busy each square of the world map is, from 0 to 1.
class HeatGrid {
  HeatGrid._(this.cells);

  static const double _spread = 1.3;
  static const int _reach = 4;

  /// Builds the grid from the visitors of a period.
  ///
  /// Places with a position are used as they are. Visitors who are known only
  /// by country are put at the middle of their country.
  factory HeatGrid.of(VisitorPlaces places) {
    final points = [
      for (final place in places.places)
        HeatPoint(place.latitude, place.longitude, place.visitors),
      for (final country in places.countries)
        if (country.unlocated > 0 && CountryCatalog.of(country.code) != null)
          HeatPoint(
            CountryCatalog.of(country.code)!.latitude,
            CountryCatalog.of(country.code)!.longitude,
            country.unlocated,
          ),
    ];
    final raw = List.generate(
      WorldMask.rows,
      (_) => List<double>.filled(WorldMask.columns, 0),
    );
    for (final point in points) {
      _spreadOver(raw, point);
    }
    final peak = raw.fold<double>(0, (best, row) => math.max(best, row.reduce(math.max)));
    if (peak <= 0) return HeatGrid._(raw);
    final scale = math.log(1 + peak);
    return HeatGrid._([
      for (final row in raw)
        [for (final value in row) value <= 0 ? 0.0 : math.log(1 + value) / scale],
    ]);
  }

  final List<List<double>> cells;

  /// True when no square has any visitors.
  bool get isEmpty => cells.every((row) => row.every((value) => value <= 0));

  /// Adds a soft blob of heat around [point].
  static void _spreadOver(List<List<double>> grid, HeatPoint point) {
    final column = (point.longitude + 180) / WorldMask.cellDegrees;
    final row = (WorldMask.topLatitude - point.latitude) / WorldMask.cellDegrees;
    for (var r = row.floor() - _reach; r <= row.floor() + _reach; r++) {
      if (r < 0 || r >= WorldMask.rows) continue;
      for (var c = column.floor() - _reach; c <= column.floor() + _reach; c++) {
        final wrapped = (c % WorldMask.columns + WorldMask.columns) % WorldMask.columns;
        final dx = c + 0.5 - column;
        final dy = r + 0.5 - row;
        final falloff = math.exp(-(dx * dx + dy * dy) / (2 * _spread * _spread));
        grid[r][wrapped] += point.visitors * falloff;
      }
    }
  }
}
