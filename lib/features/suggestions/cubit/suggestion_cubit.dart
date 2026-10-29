// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/suggestion.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../../domain/repos/suggestion_repo.dart';

enum SuggestionError { tooShort, rateLimited, signIn, network }

class SuggestionState extends Equatable {
  const SuggestionState({
    this.admin = false,
    this.busy = false,
    this.sent = false,
    this.error,
    this.inbox = const [],
  });

  final bool admin;
  final bool busy;
  final bool sent;
  final SuggestionError? error;
  final List<Suggestion> inbox;

  @override
  List<Object?> get props => [admin, busy, sent, error, inbox];
}

@injectable
class SuggestionCubit extends Cubit<SuggestionState> {
  SuggestionCubit(this._repo, this._auth)
    : super(SuggestionState(admin: _auth.session?.isAdmin ?? false));

  final SuggestionRepo _repo;
  final AuthRepo _auth;

  Future<void> loadInbox() async {
    if (!state.admin) return;
    emit(SuggestionState(admin: true, busy: true, inbox: state.inbox));
    try {
      final inbox = await _repo.inbox();
      if (!isClosed) emit(SuggestionState(admin: true, inbox: inbox));
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(SuggestionState(admin: true, error: _map(e), inbox: state.inbox));
      }
    }
  }

  Future<void> send(String text) async {
    final message = text.trim();
    if (_auth.session == null) {
      return emit(const SuggestionState(error: SuggestionError.signIn));
    }
    if (message.length < 3) {
      return emit(const SuggestionState(error: SuggestionError.tooShort));
    }
    emit(const SuggestionState(busy: true));
    try {
      await _repo.submit(message);
      if (!isClosed) emit(const SuggestionState(sent: true));
    } on ApiException catch (e) {
      if (!isClosed) emit(SuggestionState(error: _map(e)));
    }
  }

  SuggestionError _map(ApiException error) => switch (error.code) {
    'invalid_message' => SuggestionError.tooShort,
    'rate_limited' => SuggestionError.rateLimited,
    'invalid_session' => SuggestionError.signIn,
    _ => SuggestionError.network,
  };
}
