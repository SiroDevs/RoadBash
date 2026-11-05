// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/game/race/race_result.dart';
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/player_session.dart';
import '../../../domain/models/race_settlement.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../../domain/repos/wallet_repo.dart';

/// The wallet balance, whether it is being fetched, and the last settlement.
class WalletState extends Equatable {
  const WalletState({this.balance, this.loading = false, this.settlement});

  final int? balance;
  final bool loading;
  final RaceSettlement? settlement;

  WalletState copyWith({
    int? balance,
    bool? loading,
    RaceSettlement? settlement,
    bool clearSettlement = false,
  }) => WalletState(
    balance: balance ?? this.balance,
    loading: loading ?? this.loading,
    settlement: clearSettlement ? null : (settlement ?? this.settlement),
  );

  @override
  List<Object?> get props => [balance, loading, settlement];
}

/// Holds the signed-in player's wallet and settles finished races.
@lazySingleton
class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._repo, this._auth) : super(const WalletState()) {
    _sub = _auth.sessionChanges.listen(_onSession);
    if (_auth.session != null) load();
  }

  final WalletRepo _repo;
  final AuthRepo _auth;
  late final StreamSubscription<PlayerSession?> _sub;

  /// Fetches the balance, or clears the wallet when nobody is signed in.
  Future<void> load() async {
    if (_auth.session == null) return emit(const WalletState());
    emit(state.copyWith(loading: true));
    try {
      final balance = await _repo.balance();
      if (!isClosed) emit(state.copyWith(balance: balance, loading: false));
    } on ApiException {
      if (!isClosed) emit(state.copyWith(loading: false));
    }
  }

  /// Settles a race: records it, pays the prize and bonuses of a win, and
  /// charges fines and bills. [newBest] says the race set a best time for its
  /// level and scene.
  Future<void> settle(RaceResult result, {bool newBest = false}) async {
    if (_auth.session == null) return;
    emit(state.copyWith(loading: true, clearSettlement: true));
    final player = result.player;
    try {
      final settlement = await _repo.settle(
        _endOf(result),
        scene: result.scene,
        level: result.level,
        place: player.place,
        timeMs: (player.seconds * 1000).round(),
        newBest: newBest,
        clean: result.bashes == 0,
        trafficHits: result.trafficHits,
        crashKmh: result.crashKmh,
      );
      if (!isClosed) {
        emit(WalletState(balance: settlement.balance, settlement: settlement));
      }
    } on ApiException {
      if (!isClosed) emit(state.copyWith(loading: false));
      await load();
    }
  }

  /// How the race ended for the wallet.
  RaceEnd _endOf(RaceResult result) {
    if (result.crashed) return RaceEnd.crashed;
    if (result.busted) return RaceEnd.busted;
    return RaceEnd.finished;
  }

  /// Loads the wallet when a player signs in and clears it on sign-out.
  void _onSession(PlayerSession? session) {
    if (session == null) {
      emit(const WalletState());
    } else {
      load();
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
