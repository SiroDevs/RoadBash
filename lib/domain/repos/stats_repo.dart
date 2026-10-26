import '../models/stats_models.dart';

abstract interface class StatsRepo {
  Future<void> trackVisit();
  Future<int> onlineCount();
  Future<StatsSummary> summary();
  Future<List<StatsPoint>> series(StatsRange range);
  Future<List<HeatCell>> heatmap(StatsRange range);
}
