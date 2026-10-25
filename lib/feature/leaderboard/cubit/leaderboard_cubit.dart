// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/leaderboard_entry.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/repos/leaderboard_repo.dart';

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LoadStatus.loading,
    this.entries = const [],
  });

  final LoadStatus status;
  final List<LeaderboardEntry> entries;

  @override
  List<Object?> get props => [status, entries];
}

@injectable
class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._repo) : super(const LeaderboardState());

  final LeaderboardRepo _repo;

  Future<void> load() async {
    emit(const LeaderboardState());
    try {
      final entries = await _repo.top();
      if (!isClosed) {
        emit(LeaderboardState(status: LoadStatus.ready, entries: entries));
      }
    } catch (_) {
      if (!isClosed) emit(const LeaderboardState(status: LoadStatus.failed));
    }
  }
}
