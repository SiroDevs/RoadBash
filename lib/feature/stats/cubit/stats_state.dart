part of 'stats_cubit.dart';

/// Metric the activity heatmap can show.
enum HeatMetric { visitors, players }

/// What the visitor places list shows.
enum PlacesView { countries, cities }

/// State of the stats screen: status, range, metric and summary.
class StatsState extends Equatable {
  const StatsState({
    this.status = LoadStatus.loading,
    this.range = StatsRange.week,
    this.metric = HeatMetric.visitors,
    this.placesView = PlacesView.countries,
    this.summary,
    this.series = const [],
    this.heat = const [],
    this.places = VisitorPlaces.empty,
  });

  final LoadStatus status;
  final StatsRange range;
  final HeatMetric metric;
  final PlacesView placesView;
  final StatsSummary? summary;
  final List<StatsPoint> series;
  final List<HeatCell> heat;
  final VisitorPlaces places;

  /// Returns a copy with the given fields replaced.
  StatsState copyWith({
    LoadStatus? status,
    StatsRange? range,
    HeatMetric? metric,
    PlacesView? placesView,
    StatsSummary? summary,
    List<StatsPoint>? series,
    List<HeatCell>? heat,
    VisitorPlaces? places,
  }) => StatsState(
    status: status ?? this.status,
    range: range ?? this.range,
    metric: metric ?? this.metric,
    placesView: placesView ?? this.placesView,
    summary: summary ?? this.summary,
    series: series ?? this.series,
    heat: heat ?? this.heat,
    places: places ?? this.places,
  );

  @override
  List<Object?> get props => [
    status,
    range,
    metric,
    placesView,
    summary,
    series,
    heat,
    places,
  ];
}
