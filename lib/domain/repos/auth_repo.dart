// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/supabase/api_client.dart';
import '../models/name_status.dart';
import '../models/player_session.dart';

@lazySingleton
class AuthRepo {
  AuthRepo(this._api);

  final ApiClient _api;

  Future<NameStatus> checkName(String name) async =>
      NameStatus.fromJson(await _api.call('rb_name_status', {'p_name': name}));

  Future<void> checkChallenge(String name, String answer) async {
    await _api.call('rb_check_challenge', {
      'p_name': name,
      'p_challenge': answer,
    });
  }

  Future<PlayerSession> register({
    required String name,
    required String question,
    required String answer,
    String? challenge,
  }) async => PlayerSession.fromJson(
    await _api.call('rb_register', {
      'p_name': name,
      'p_question': question,
      'p_answer': answer,
      'p_challenge': challenge,
    }),
  );

  Future<PlayerSession> login(String name, String answer) async =>
      PlayerSession.fromJson(
        await _api.call('rb_login', {'p_name': name, 'p_answer': answer}),
      );

  Future<void> logout() async {
    final current = _api.session;
    _api.setSession(null);
    if (current == null) return;
    try {
      await _api.call('rb_logout', {'p_token': current.token});
    } catch (_) {}
  }
}
