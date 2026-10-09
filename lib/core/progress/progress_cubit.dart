// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/race_record.dart';
import '../../domain/models/scene_id.dart';
import '../../domain/repos/race_repo.dart';
import '../game/race/race_result.dart';

part 'progress_state.dart';

@lazySingleton
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._repo) : super(const ProgressState());

  final RaceRepo _repo;

  Future<void> load() async =>
      emit(ProgressState(records: await _repo.all(), loaded: true));

  /// Saves the player's result and returns true if it beat their best time.
  Future<bool> record(RaceResult result) async {
    final row = result.player;
    final record = RaceRecord(
      scene: result.scene,
      place: row.place,
      timeMs: (row.seconds * 1000).round(),
      playerName: row.name,
      finishedAt: DateTime.now(),
    );
    final best = state.statsFor(result.scene).bestMs;
    await _repo.add(record);
    emit(ProgressState(records: [...state.records, record], loaded: true));
    return best == null || record.timeMs < best;
  }
}
