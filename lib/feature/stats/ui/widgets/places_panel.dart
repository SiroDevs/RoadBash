// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_chips.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/visitor_places.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../cubit/stats_cubit.dart';
import '../world/world_heat_map.dart';
import 'place_rows.dart';

/// The visitor places section: a heat map of the world with the countries or
/// places listed under it.
class PlacesPanel extends StatelessWidget {
  const PlacesPanel({
    super.key,
    required this.places,
    required this.view,
    required this.onView,
    required this.l10n,
  });

  final VisitorPlaces places;
  final PlacesView view;
  final ValueChanged<PlacesView> onView;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.statsPlacesTitle, style: retroBody(size: sizes.small)),
        SizedBox(height: sizes.gapSmall),
        if (places.hasNone)
          Text(l10n.statsPlacesEmpty, style: retroBody(size: sizes.caption, color: Retro.dim))
        else ..._content(sizes),
        if (places.unknown > 0) ...[
          SizedBox(height: sizes.gapSmall),
          Text(
            l10n.statsPlacesUnknown(places.unknown),
            style: retroBody(size: sizes.caption, color: Retro.dim),
          ),
        ],
      ],
    )
        .padding(all: sizes.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }

  /// Builds the map, the tabs, the list and the note.
  List<Widget> _content(RetroSizes sizes) {
    final rows = view == PlacesView.countries
        ? PlaceRows.countries(places)
        : PlaceRows.cities(places);
    final more = rows.total - rows.shown;
    return [
      WorldHeatMap(places: places),
      SizedBox(height: sizes.gap),
      RetroChips<PlacesView>(
        items: {
          PlacesView.countries: l10n.statsPlacesCountries,
          PlacesView.cities: l10n.statsPlacesCities,
        },
        selected: view,
        onSelected: onView,
      ),
      SizedBox(height: sizes.gapSmall),
      rows,
      if (more > 0)
        Text(
          l10n.statsPlacesMore(more),
          style: retroBody(size: sizes.caption, color: Retro.dim),
        ).padding(top: sizes.gapSmall),
      SizedBox(height: sizes.gapSmall),
      Text(l10n.statsPlacesNote, style: retroBody(size: sizes.caption, color: Retro.dim)),
    ];
  }
}
