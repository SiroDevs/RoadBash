// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/load_status.dart';
import '../../../domain/models/stats_models.dart';
import '../../../domain/models/visitor_places.dart';
import '../../../domain/repos/stats_repo.dart';

part 'stats_state.dart';

/// Loads stats for the selected range and heatmap metric.
@injectable
class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._repo) : super(const StatsState());

  final StatsRepo _repo;
  Timer? _poll;

  /// Loads the summary for the current range and reports success or failure.
  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final range = state.range;
      final results = await Future.wait<Object>([
        _repo.summary(),
        _repo.series(range),
        _repo.heatmap(range),
        _places(range),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: LoadStatus.ready,
          summary: results[0] as StatsSummary,
          series: results[1] as List<StatsPoint>,
          heat: results[2] as List<HeatCell>,
          places: results[3] as VisitorPlaces,
        ),
      );
      _poll ??= Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
    } catch (_) {
      if (!isClosed) emit(state.copyWith(status: LoadStatus.failed));
    }
  }

  /// Changes the range and reloads the stats.
  Future<void> setRange(StatsRange range) async {
    if (range == state.range) return;
    emit(state.copyWith(range: range));
    await load();
  }

  /// Changes the metric shown by the heatmap.
  void setMetric(HeatMetric metric) => emit(state.copyWith(metric: metric));

  /// Changes what the visitor places list shows.
  void setPlacesView(PlacesView view) =>
      emit(state.copyWith(placesView: view));

  /// Loads where the visitors come from, treating a failure as no data so the
  /// rest of the stats still show.
  Future<VisitorPlaces> _places(StatsRange range) async {
    try {
      return await _repo.places(range);
    } catch (_) {
      return VisitorPlaces.empty;
    }
  }

  /// Refreshes the summary quietly, without showing the loading state.
  Future<void> _refresh() async {
    try {
      final summary = await _repo.summary();
      if (!isClosed) emit(state.copyWith(summary: summary));
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _poll?.cancel();
    return super.close();
  }
}
