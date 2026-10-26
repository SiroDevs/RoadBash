// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/player_session.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';

part 'auth_state.dart';

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
  }

  final AuthRepo _repo;
  final SettingsCubit _settings;
  final ProgressCubit _progress;
  late final StreamSubscription<PlayerSession?> _sub;

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

  Future<void> signedIn(PlayerSession session) async {
    _repo.saveSession(session);
    _repo.setSession(session);
    _settings.setName(session.name);
    emit(AuthState(session: session));
    await _progress.load();
  }

  Future<void> playAnonymously() async {
    _repo.saveAnonymous();
    _settings.setName(AppConstants.anonymousName);
    emit(const AuthState(anonymous: true));
    await _progress.load();
  }

  Future<void> signOut() async {
    _repo.clearSaved();
    await _repo.logout();
    emit(const AuthState());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
