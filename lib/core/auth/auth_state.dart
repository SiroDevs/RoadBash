part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({this.session, this.offline = false});

  final PlayerSession? session;
  final bool offline;

  bool get isSignedIn => session != null || offline;
  bool get isAdmin => session?.isAdmin ?? false;

  @override
  List<Object?> get props => [session, offline];
}
