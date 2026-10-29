// Project imports:
import '../models/name_status.dart';
import '../models/player_session.dart';

/// Contract for sign-in, sessions and name checks.
abstract interface class AuthRepo {
  PlayerSession? get session;
  Stream<PlayerSession?> get sessionChanges;
  void setSession(PlayerSession? session);

  PlayerSession? get savedSession;
  bool get savedAnonymous;
  void saveSession(PlayerSession session);
  void saveAnonymous();
  void clearSaved();

  Future<NameStatus> checkName(String name);
  Future<void> checkChallenge(String name, String answer);
  Future<PlayerSession> register({
    required String name,
    required String question,
    required String answer,
    String? challenge,
  });
  Future<PlayerSession> login(String name, String answer);
  Future<void> logout();
}
