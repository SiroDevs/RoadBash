// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/game/race/race_result.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../../wallet/cubit/wallet_cubit.dart';

/// Result of a finished race, whether it set a new best time for its level,
/// and the level the race opened, if any.
class RaceOutcome extends Equatable {
  const RaceOutcome({
    required this.result,
    required this.newBest,
    this.levelUp,
  });

  final RaceResult result;
  final bool newBest;
  final int? levelUp;

  @override
  List<Object?> get props => [result, newBest, levelUp];
}

/// Receives a finished race, records it, updates the career and settles the
/// wallet once.
@injectable
class RaceCubit extends Cubit<RaceOutcome?> {
  RaceCubit(this._progress, this._wallet) : super(null);

  final ProgressCubit _progress;
  final WalletCubit _wallet;

  /// Records the result and emits the outcome.
  Future<void> finish(RaceResult result) async {
    if (state != null) return;
    if (result.finished) await _progress.record(result);
    final update = await _progress.updateCareer(result);
    unawaited(_wallet.settle(result, newBest: update.newBest));
    if (!isClosed) {
      emit(
        RaceOutcome(
          result: result,
          newBest: update.newBest,
          levelUp: update.levelUp,
        ),
      );
    }
  }
}
