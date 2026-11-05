// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/leaderboard_entry.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/repos/leaderboard_repo.dart';

/// State of the leaderboard: period, load status and entries.
class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.period = LeaderboardPeriod.thisWeek,
    this.status = LoadStatus.loading,
    this.entries = const [],
    this.from,
    this.to,
  });

  final LeaderboardPeriod period;
  final LoadStatus status;
  final List<LeaderboardEntry> entries;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [period, status, entries, from, to];
}

/// Loads the leaderboard of the selected period, starting with this week.
@injectable
class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._repo) : super(const LeaderboardState());

  final LeaderboardRepo _repo;

  /// Loads the top players of the current period and reports success or
  /// failure.
  Future<void> load() async {
    final period = state.period;
    emit(LeaderboardState(period: period));
    try {
      final board = await _repo.top(period);
      if (isClosed || state.period != period) return;
      emit(
        LeaderboardState(
          period: period,
          status: LoadStatus.ready,
          entries: board.entries,
          from: board.from,
          to: board.to,
        ),
      );
    } catch (_) {
      if (!isClosed && state.period == period) {
        emit(LeaderboardState(period: period, status: LoadStatus.failed));
      }
    }
  }

  /// Switches to another period and loads it.
  Future<void> setPeriod(LeaderboardPeriod period) async {
    if (period == state.period) return;
    emit(LeaderboardState(period: period));
    await load();
  }
}
