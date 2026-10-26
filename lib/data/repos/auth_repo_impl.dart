import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../domain/models/name_status.dart';
import '../../domain/models/player_session.dart';
import '../../domain/repos/auth_repo.dart';
import '../mappers/auth_mapper.dart';
import '../sources/local/pref_keys.dart';
import '../sources/local/prefs_source.dart';
import '../sources/remote/api_client.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._api, this._prefs);

  final ApiClient _api;
  final PrefsSource _prefs;

  @override
  PlayerSession? get session => _api.session;

  @override
  Stream<PlayerSession?> get sessionChanges => _api.sessionChanges;

  @override
  void setSession(PlayerSession? session) => _api.setSession(session);

  @override
  PlayerSession? get savedSession {
    final raw = _prefs.getString(PrefKeys.authSession);
    if (raw.isEmpty) return null;
    try {
      return playerSessionFromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      clearSaved();
      return null;
    }
  }

  @override
  bool get savedAnonymous => _prefs.getBool(PrefKeys.authAnonymous);

  @override
  void saveSession(PlayerSession session) {
    clearSaved();
    _prefs.setString(
      PrefKeys.authSession,
      jsonEncode(playerSessionToJson(session)),
    );
  }

  @override
  void saveAnonymous() {
    clearSaved();
    _prefs.setBool(PrefKeys.authAnonymous, true);
  }

  @override
  void clearSaved() {
    _prefs.remove(PrefKeys.authSession);
    _prefs.remove(PrefKeys.authAnonymous);
  }

  @override
  Future<NameStatus> checkName(String name) async =>
      nameStatusFromJson(await _api.call('rb_name_status', {'p_name': name}));

  @override
  Future<void> checkChallenge(String name, String answer) async {
    await _api.call('rb_check_challenge', {
      'p_name': name,
      'p_challenge': answer,
    });
  }

  @override
  Future<PlayerSession> register({
    required String name,
    required String question,
    required String answer,
    String? challenge,
  }) async => playerSessionFromJson(
    await _api.call('rb_register', {
      'p_name': name,
      'p_question': question,
      'p_answer': answer,
      'p_challenge': challenge,
    }),
  );

  @override
  Future<PlayerSession> login(String name, String answer) async =>
      playerSessionFromJson(
        await _api.call('rb_login', {'p_name': name, 'p_answer': answer}),
      );

  @override
  Future<void> logout() async {
    final current = _api.session;
    _api.setSession(null);
    if (current == null) return;
    try {
      await _api.call('rb_logout', {'p_token': current.token});
    } catch (_) {}
  }
}
