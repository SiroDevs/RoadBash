// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../game/race/race_result.dart';
import '../../progress/cubit/progress_cubit.dart';

class RaceOutcome extends Equatable {
  const RaceOutcome({required this.result, required this.newBest});

  final RaceResult result;
  final bool newBest;

  @override
  List<Object?> get props => [result, newBest];
}

/// Null while racing; holds the saved outcome once the rider finishes.
@injectable
class RaceCubit extends Cubit<RaceOutcome?> {
  RaceCubit(this._progress) : super(null);

  final ProgressCubit _progress;

  Future<void> finish(RaceResult result) async {
    if (state != null) return;
    final newBest = await _progress.record(result);
    if (!isClosed) emit(RaceOutcome(result: result, newBest: newBest));
  }
}
