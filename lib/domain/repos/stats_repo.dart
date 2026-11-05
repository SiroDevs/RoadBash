// Project imports:
import '../models/stats_models.dart';
import '../models/visitor_places.dart';

/// Contract for tracking visits and reading stats.
abstract interface class StatsRepo {
  Future<void> trackVisit();
  Future<int> onlineCount();
  Future<StatsSummary> summary();
  Future<List<StatsPoint>> series(StatsRange range);
  Future<List<HeatCell>> heatmap(StatsRange range);
  Future<VisitorPlaces> places(StatsRange range);
}
