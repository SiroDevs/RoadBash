part of 'stats_cubit.dart';

/// Metric the activity heatmap can show.
enum HeatMetric { visitors, players }

/// State of the stats screen: status, range, metric and summary.
class StatsState extends Equatable {
  const StatsState({
    this.status = LoadStatus.loading,
    this.range = StatsRange.week,
    this.metric = HeatMetric.visitors,
    this.summary,
    this.series = const [],
    this.heat = const [],
  });

  final LoadStatus status;
  final StatsRange range;
  final HeatMetric metric;
  final StatsSummary? summary;
  final List<StatsPoint> series;
  final List<HeatCell> heat;

  /// Returns a copy with the given fields replaced.
  StatsState copyWith({
    LoadStatus? status,
    StatsRange? range,
    HeatMetric? metric,
    StatsSummary? summary,
    List<StatsPoint>? series,
    List<HeatCell>? heat,
  }) => StatsState(
    status: status ?? this.status,
    range: range ?? this.range,
    metric: metric ?? this.metric,
    summary: summary ?? this.summary,
    series: series ?? this.series,
    heat: heat ?? this.heat,
  );

  @override
  List<Object?> get props => [status, range, metric, summary, series, heat];
}
