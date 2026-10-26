// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/load_status.dart';
import '../../../domain/models/stats_models.dart';
import '../../../domain/repos/stats_repo.dart';

part 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._repo) : super(const StatsState());

  final StatsRepo _repo;
  Timer? _poll;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final range = state.range;
      final results = await Future.wait<Object>([
        _repo.summary(),
        _repo.series(range),
        _repo.heatmap(range),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: LoadStatus.ready,
          summary: results[0] as StatsSummary,
          series: results[1] as List<StatsPoint>,
          heat: results[2] as List<HeatCell>,
        ),
      );
      _poll ??= Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
    } catch (_) {
      if (!isClosed) emit(state.copyWith(status: LoadStatus.failed));
    }
  }

  Future<void> setRange(StatsRange range) async {
    if (range == state.range) return;
    emit(state.copyWith(range: range));
    await load();
  }

  void setMetric(HeatMetric metric) => emit(state.copyWith(metric: metric));

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
