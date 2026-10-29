part of 'sign_in_cubit.dart';

/// Steps of the sign-in flow.
enum SignInStage { name, answer, create, challenge }

/// Errors the sign-in flow can show.
enum SignInError {
  invalidName,
  wrongAnswer,
  locked,
  network,
  notConfigured,
  nameTaken,
  wrongChallenge,
  invalidQuestion,
  invalidAnswer,
  mismatch,
  generic,
}

/// State of the sign-in flow: stage, name, question, busy and error.
class SignInState extends Equatable {
  const SignInState({
    this.stage = SignInStage.name,
    this.name = '',
    this.question = '',
    this.busy = false,
    this.error,
    this.number = 0,
  });

  final SignInStage stage;
  final String name;
  final String question;
  final bool busy;
  final SignInError? error;
  final int number;

  /// Returns a copy with the given fields replaced.
  SignInState copyWith({
    SignInStage? stage,
    String? name,
    String? question,
    bool? busy,
    SignInError? error,
    int number = 0,
    bool clearError = false,
  }) => SignInState(
    stage: stage ?? this.stage,
    name: name ?? this.name,
    question: question ?? this.question,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
    number: number,
  );

  @override
  List<Object?> get props => [stage, name, question, busy, error, number];
}
