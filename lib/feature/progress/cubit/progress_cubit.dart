// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/game/race/race_result.dart';
import '../../../domain/models/career.dart';
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/race_record.dart';
import '../../../domain/models/scene_id.dart';
import '../../../domain/repos/career_repo.dart';
import '../../../domain/repos/race_repo.dart';

part 'progress_state.dart';

/// Holds race history and records new results.
@lazySingleton
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._repo, this._careerRepo) : super(const ProgressState());

  final RaceRepo _repo;
  final CareerRepo _careerRepo;

  /// Loads saved race records and the career.
  Future<void> load() async => emit(
    ProgressState(
      records: await _repo.all(),
      career: await _careerRepo.load(),
      loaded: true,
    ),
  );

  /// Takes a higher level from the player's account; a level never goes down.
  Future<void> applyLevel(int level) async {
    final career = state.career;
    final capped = level.clamp(1, LevelRules.top).toInt();
    if (capped <= career.level) return;
    final next = career.copyWith(level: capped, streak: 0);
    await _careerRepo.save(next);
    emit(state.copyWith(career: next));
  }

  /// Saves a finished race; returns true if it is a new best time.
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
    emit(state.copyWith(records: [...state.records, record]));
    return best == null || record.timeMs < best;
  }

  /// Updates the career after a race: the win streak, the level and the best
  /// times. The money side is settled by the wallet.
  ///
  /// Winning [LevelRules.winsToAdvance] races in a row at a level opens the
  /// next one; any other result, including a crash or an arrest, starts the
  /// streak again.
  Future<CareerUpdate> updateCareer(RaceResult result) async {
    final career = state.career;
    final key = Career.key(result.level, result.scene);
    final timeMs = (result.player.seconds * 1000).round();
    final previous = career.bests[key];
    final newBest = result.finished && (previous == null || timeMs < previous);

    var level = career.level;
    var streak = result.won ? career.streak + 1 : 0;
    int? levelUp;
    if (streak >= LevelRules.winsToAdvance && level < LevelRules.top) {
      level++;
      streak = 0;
      levelUp = level;
    }
    final next = career.copyWith(
      level: level,
      streak: streak,
      bests: newBest ? {...career.bests, key: timeMs} : null,
    );
    await _careerRepo.save(next);
    emit(state.copyWith(career: next));
    return CareerUpdate(newBest: newBest, levelUp: levelUp);
  }
}

/// What a race changed in the career.
class CareerUpdate {
  const CareerUpdate({required this.newBest, this.levelUp});

  /// True when the race set a new best time for its level and scene.
  final bool newBest;

  /// The level the player reached with the race, or null if none.
  final int? levelUp;
}
