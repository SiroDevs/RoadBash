part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({this.session, this.anonymous = false});

  final PlayerSession? session;
  final bool anonymous;

  bool get isSignedIn => session != null || anonymous;
  bool get isAdmin => session?.isAdmin ?? false;

  @override
  List<Object?> get props => [session, anonymous];
}
