// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/geo/country_catalog.dart';
import '../../../../domain/geo/country_info.dart';
import '../../../../domain/models/visitor_places.dart';

/// Rows listing the countries or places visitors come from, each with a bar
/// showing its share of the busiest one.
class PlaceRows extends StatelessWidget {
  const PlaceRows.countries(this.places, {super.key, this.shown = 8})
    : cities = false;

  const PlaceRows.cities(this.places, {super.key, this.shown = 10})
    : cities = true;

  final VisitorPlaces places;
  final bool cities;
  final int shown;

  /// How many rows exist in total, shown or not.
  int get total => cities ? places.places.length : places.countries.length;

  @override
  Widget build(BuildContext context) {
    final rows = _rows();
    final peak = rows.isEmpty ? 1 : rows.first.$3;
    final sizes = context.sizes;
    return Column(
      children: [
        for (final row in rows.take(shown))
          _row(sizes, row.$1, row.$2, row.$3, row.$3 / peak),
      ],
    );
  }

  /// Builds the flag, label and visitor count of every row, busiest first.
  List<(String, String, int)> _rows() => cities
      ? [
          for (final place in places.places)
            (
              CountryInfo.flagOf(place.countryCode),
              _placeLabel(place),
              place.visitors,
            ),
        ]
      : [
          for (final country in places.countries)
            (CountryInfo.flagOf(country.code), country.name, country.visitors),
        ];

  /// Names a place by its city and country.
  String _placeLabel(PlaceStat place) {
    final country = CountryCatalog.nameOf(place.countryCode);
    final city = place.city.isNotEmpty ? place.city : place.region;
    return city.isEmpty ? country : '$city, $country';
  }

  /// Builds one row with a share bar behind its label.
  Widget _row(RetroSizes sizes, String flag, String label, int count, double share) =>
      Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: share.clamp(0.02, 1.0),
              child: const ColoredBox(color: Color(0x33FFB020)),
            ),
          ),
          Row(
            children: [
              Text(flag, style: retroBody(size: sizes.small)).padding(right: sizes.gapSmall),
              Text(
                label,
                style: retroBody(size: sizes.small),
                overflow: TextOverflow.ellipsis,
              ).expanded(),
              Text('$count', style: retroBody(size: sizes.small, color: Retro.yellow)),
            ],
          ).padding(horizontal: sizes.gapSmall, vertical: sizes.gapSmall * 0.5),
        ],
      ).padding(vertical: 1);
}
