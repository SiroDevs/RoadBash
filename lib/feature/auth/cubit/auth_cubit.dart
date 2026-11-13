// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/player_session.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';

part 'auth_state.dart';

/// Holds the signed-in session and keeps it in sync with storage.
@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo, this._settings, this._progress)
    : super(const AuthState()) {
    _sub = _repo.sessionChanges.listen((session) {
      if (session == null && state.session != null) {
        _repo.clearSaved();
        emit(const AuthState());
      }
    });
    _levelSub = _progress.stream
        .map((progress) => progress.level)
        .distinct()
        .listen((_) => syncLevel());
  }

  final AuthRepo _repo;
  final SettingsCubit _settings;
  final ProgressCubit _progress;
  late final StreamSubscription<PlayerSession?> _sub;
  late final StreamSubscription<int> _levelSub;
  Future<void>? _levelSync;
  String? _levelSyncAccount;
  int _syncedLevel = 0;

  /// Restores the saved session or anonymous mode on startup.
  Future<void> restore() async {
    if (state.isSignedIn) return;
    final session = _repo.savedSession;
    if (session != null) {
      _repo.setSession(session);
      _settings.setName(session.name);
      emit(AuthState(session: session));
    } else if (_repo.savedAnonymous) {
      _settings.setName(AppConstants.anonymousName);
      emit(const AuthState(anonymous: true));
    }
  }

  /// Stores a new session and applies the player name and progress.
  Future<void> signedIn(PlayerSession session) async {
    _repo.saveSession(session);
    _repo.setSession(session);
    _settings.setName(session.name);
    emit(AuthState(session: session));
    _syncedLevel = 0;
    await _progress.load(state.accountKey);
    await syncLevel();
  }

  /// Sends the level reached in this session and takes the level kept on the
  /// account into the career. Does nothing offline or when not signed in.
  Future<void> syncLevel() {
    final account = state.session?.playerId;
    if (account == null) return Future<void>.value();
    final pending = _levelSync;
    if (pending != null && _levelSyncAccount == account) return pending;
    late final Future<void> task;
    task = _syncLevel(account).whenComplete(() {
      if (!identical(_levelSync, task)) return;
      _levelSync = null;
      _levelSyncAccount = null;
    });
    _levelSyncAccount = account;
    _levelSync = task;
    return task;
  }

  Future<void> _syncLevel(String account) async {
    while (state.session?.playerId == account) {
      final level = _progress.state.level;
      if (level <= _syncedLevel) return;
      final previous = _syncedLevel;
      _syncedLevel = level;
      try {
        final remote = await _repo.syncLevel(level);
        if (state.session?.playerId != account) return;
        if (remote > level) _syncedLevel = remote;
        await _progress.applyLevel(remote);
      } on ApiException {
        if (state.session?.playerId == account) _syncedLevel = previous;
        return;
      }
    }
  }

  /// Switches to anonymous play without an account.
  Future<void> playAnonymously() async {
    _repo.saveAnonymous();
    _settings.setName(AppConstants.anonymousName);
    emit(const AuthState(anonymous: true));
    _syncedLevel = 0;
    await _progress.load(state.accountKey);
  }

  /// Clears the saved session and signs out.
  Future<void> signOut() async {
    _repo.clearSaved();
    await _repo.logout();
    _syncedLevel = 0;
    emit(const AuthState());
    await _progress.load(state.accountKey);
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _levelSub.cancel();
    return super.close();
  }
}
