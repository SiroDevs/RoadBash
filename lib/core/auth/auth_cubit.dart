// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/player_session.dart';
import '../../domain/repos/auth_repo.dart';
import '../progress/progress_cubit.dart';
import '../settings/settings_cubit.dart';
import '../supabase/api_client.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo, this._api, this._settings, this._progress)
    : super(const AuthState()) {
    _sub = _api.sessionChanges.listen((session) {
      if (session == null && state.session != null) emit(const AuthState());
    });
  }

  final AuthRepo _repo;
  final ApiClient _api;
  final SettingsCubit _settings;
  final ProgressCubit _progress;
  late final StreamSubscription<PlayerSession?> _sub;

  Future<void> signedIn(PlayerSession session) async {
    _api.setSession(session);
    _settings.setName(session.name);
    emit(AuthState(session: session));
    await _progress.load();
  }

  Future<void> playOffline() async {
    emit(const AuthState(offline: true));
    await _progress.load();
  }

  Future<void> signOut() async {
    await _repo.logout();
    emit(const AuthState());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
