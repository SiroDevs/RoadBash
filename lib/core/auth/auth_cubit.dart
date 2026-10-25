// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import '../../common/constants/pref_constants.dart';
import '../../domain/models/player_session.dart';
import '../../domain/repos/auth_repo.dart';
import '../../domain/repos/prefs_repo.dart';
import '../progress/progress_cubit.dart';
import '../settings/settings_cubit.dart';
import '../supabase/api_client.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo, this._api, this._settings, this._progress, this._prefs)
    : super(const AuthState()) {
    _sub = _api.sessionChanges.listen((session) {
      if (session == null && state.session != null) {
        _forget();
        emit(const AuthState());
      }
    });
  }

  final AuthRepo _repo;
  final ApiClient _api;
  final SettingsCubit _settings;
  final ProgressCubit _progress;
  final PrefsRepo _prefs;
  late final StreamSubscription<PlayerSession?> _sub;

  Future<void> restore() async {
    if (state.isSignedIn) return;
    final raw = _prefs.getPrefString(PrefConstants.authSessionKey);
    if (raw.isNotEmpty) {
      try {
        final session = PlayerSession.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map),
        );
        _api.setSession(session);
        _settings.setName(session.name);
        emit(AuthState(session: session));
        return;
      } catch (_) {
        _forget();
      }
    }
    if (_prefs.getPrefBool(PrefConstants.authAnonymousKey)) {
      _settings.setName(AppConstants.anonymousName);
      emit(const AuthState(anonymous: true));
    }
  }

  void _remember({PlayerSession? session}) {
    _forget();
    if (session == null) {
      _prefs.setPrefBool(PrefConstants.authAnonymousKey, true);
      return;
    }
    _prefs.setPrefString(
      PrefConstants.authSessionKey,
      jsonEncode({
        'token': session.token,
        'player_id': session.playerId,
        'name': session.name,
        'is_admin': session.isAdmin,
      }),
    );
  }

  void _forget() {
    _prefs.removeKeyPair(PrefConstants.authSessionKey);
    _prefs.removeKeyPair(PrefConstants.authAnonymousKey);
  }

  Future<void> signedIn(PlayerSession session) async {
    _remember(session: session);
    _api.setSession(session);
    _settings.setName(session.name);
    emit(AuthState(session: session));
    await _progress.load();
  }

  Future<void> playAnonymously() async {
    _remember();
    _settings.setName(AppConstants.anonymousName);
    emit(const AuthState(anonymous: true));
    await _progress.load();
  }

  Future<void> signOut() async {
    _forget();
    await _repo.logout();
    emit(const AuthState());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}