// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/name_status.dart';
import '../../../domain/repos/auth_repo.dart';
import 'auth_cubit.dart';

part 'sign_in_state.dart';

/// Drives the multi-step sign-in and account creation flow.
@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._repo, this._auth) : super(const SignInState());

  final AuthRepo _repo;
  final AuthCubit _auth;
  String _challenge = '';

  /// Checks the typed name and moves to the matching next stage.
  Future<void> submitName(String raw) => _run(() async {
    final name = raw.trim();
    final status = await _repo.checkName(name);
    switch (status.check) {
      case NameCheck.invalid:
        emit(state.copyWith(busy: false, error: SignInError.invalidName));
      case NameCheck.available:
        emit(SignInState(stage: SignInStage.create, name: name));
      case NameCheck.taken:
        emit(
          SignInState(
            stage: SignInStage.answer,
            name: status.name ?? name,
            question: status.question ?? '',
          ),
        );
      case NameCheck.reservedOpen:
        emit(SignInState(stage: SignInStage.challenge, name: name));
    }
  });

  /// Verifies the challenge answer before account creation.
  Future<void> submitChallenge(String answer) => _run(() async {
    await _repo.checkChallenge(state.name, answer);
    _challenge = answer;
    emit(SignInState(stage: SignInStage.create, name: state.name));
  });

  /// Logs in an existing player with their answer.
  Future<void> submitAnswer(String answer) => _run(() async {
    final session = await _repo.login(state.name, answer);
    await _auth.signedIn(session);
  });

  /// Creates a new account after validating question, answer and confirm.
  Future<void> submitCreate({
    required String question,
    required String answer,
    required String confirm,
  }) async {
    final trimmedQuestion = question.trim();
    final trimmedAnswer = answer.trim();
    if (trimmedQuestion.length < 5 || trimmedQuestion.length > 80) {
      return _reject(SignInError.invalidQuestion);
    }
    if (trimmedAnswer.length < 2 || trimmedAnswer.length > 60) {
      return _reject(SignInError.invalidAnswer);
    }
    if (trimmedAnswer.toLowerCase() != confirm.trim().toLowerCase()) {
      return _reject(SignInError.mismatch);
    }
    await _run(() async {
      final session = await _repo.register(
        name: state.name,
        question: trimmedQuestion,
        answer: trimmedAnswer,
        challenge: _challenge.isEmpty ? null : _challenge,
      );
      await _auth.signedIn(session);
    });
  }

  /// Returns to the first sign-in stage.
  void back() {
    _challenge = '';
    emit(const SignInState());
  }

  /// Skips sign-in and plays anonymously.
  void playAnonymously() => _auth.playAnonymously();

  /// Shows the given error and stops the busy state.
  void _reject(SignInError error) =>
      emit(state.copyWith(busy: false, error: error));

  /// Runs an async step with busy state and error mapping.
  Future<void> _run(Future<void> Function() body) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await body();
    } on ApiException catch (e) {
      if (e.code == 'wrong_challenge' && state.stage == SignInStage.create) {
        emit(SignInState(stage: SignInStage.challenge, name: state.name));
      }
      emit(
        state.copyWith(
          busy: false,
          error: _map(e.code),
          number: _number(e),
        ),
      );
    }
  }

  /// Returns attempts left, or minutes until a lockout ends.
  int _number(ApiException error) => error.retryAfter != null
      ? (error.retryAfter! / 60).ceil()
      : (error.remaining ?? 0);

  /// Maps a server error code to a [SignInError].
  SignInError _map(String code) => switch (code) {
    'invalid_name' || 'unknown_name' => SignInError.invalidName,
    'wrong_answer' => SignInError.wrongAnswer,
    'locked' => SignInError.locked,
    'network' || 'server' => SignInError.network,
    'not_configured' => SignInError.notConfigured,
    'name_taken' => SignInError.nameTaken,
    'wrong_challenge' || 'challenge_required' => SignInError.wrongChallenge,
    'invalid_question' => SignInError.invalidQuestion,
    'invalid_answer' => SignInError.invalidAnswer,
    _ => SignInError.generic,
  };
}
