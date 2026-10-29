part of 'auth_cubit.dart';

/// Whether the player is signed in, anonymous or admin.
class AuthState extends Equatable {
  const AuthState({this.session, this.anonymous = false});

  final PlayerSession? session;
  final bool anonymous;

  /// True when a session exists.
  bool get isSignedIn => session != null || anonymous;
  /// True when the session belongs to an admin.
  bool get isAdmin => session?.isAdmin ?? false;

  @override
  List<Object?> get props => [session, anonymous];
}
