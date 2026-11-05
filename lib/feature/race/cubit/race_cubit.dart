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

/// Result of a finished race and whether it set a new best time.
class RaceOutcome extends Equatable {
  const RaceOutcome({required this.result, required this.newBest});

  final RaceResult result;
  final bool newBest;

  @override
  List<Object?> get props => [result, newBest];
}

/// Receives a finished race, records it and settles the wallet once.
@injectable
class RaceCubit extends Cubit<RaceOutcome?> {
  RaceCubit(this._progress, this._wallet) : super(null);

  final ProgressCubit _progress;
  final WalletCubit _wallet;

  /// Records the result and emits the outcome.
  Future<void> finish(RaceResult result) async {
    if (state != null) return;
    final counts = !result.busted && !result.crashed;
    final newBest = counts ? await _progress.record(result) : false;
    unawaited(_wallet.settle(result));
    if (!isClosed) emit(RaceOutcome(result: result, newBest: newBest));
  }
}
