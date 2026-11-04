// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/models/post.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../../domain/repos/post_repo.dart';

/// Errors the boardroom can show.
enum BoardroomError { tooShort, rateLimited, signIn, forbidden, network }

/// The two filter strips of the boardroom.
enum BoardroomTab { announcements, suggestions }

/// State of the boardroom: who is looking, the strip, the posts and errors.
class BoardroomState extends Equatable {
  const BoardroomState({
    this.admin = false,
    this.tab = BoardroomTab.announcements,
    this.status = LoadStatus.loading,
    this.busy = false,
    this.error,
    this.posts = const [],
  });

  final bool admin;
  final BoardroomTab tab;
  final LoadStatus status;
  final bool busy;
  final BoardroomError? error;
  final List<Post> posts;

  /// The kind of post the selected strip shows.
  PostKind get tabKind => tab == BoardroomTab.announcements
      ? PostKind.announcement
      : PostKind.suggestion;

  /// Admins write announcements and players write suggestions.
  bool get canCompose => tab == BoardroomTab.announcements ? admin : !admin;

  /// The posts of the selected strip.
  List<Post> get shownPosts => [
    for (final post in posts)
      if (post.kind == tabKind) post,
  ];

  BoardroomState copyWith({
    BoardroomTab? tab,
    LoadStatus? status,
    bool? busy,
    BoardroomError? error,
    bool clearError = false,
    List<Post>? posts,
  }) => BoardroomState(
    admin: admin,
    tab: tab ?? this.tab,
    status: status ?? this.status,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
    posts: posts ?? this.posts,
  );

  @override
  List<Object?> get props => [admin, tab, status, busy, error, posts];
}

/// Loads the boardroom and handles posting, replying, publishing, deleting.
@injectable
class BoardroomCubit extends Cubit<BoardroomState> {
  BoardroomCubit(this._repo, this._auth)
    : super(BoardroomState(admin: _auth.session?.isAdmin ?? false));

  final PostRepo _repo;
  final AuthRepo _auth;

  /// Switches between the announcements and the suggestions.
  void setTab(BoardroomTab tab) =>
      emit(state.copyWith(tab: tab, clearError: true));

  /// Loads the posts the player may see.
  Future<void> load() async {
    if (_auth.session == null) {
      return emit(
        state.copyWith(status: LoadStatus.failed, error: BoardroomError.signIn),
      );
    }
    emit(state.copyWith(status: LoadStatus.loading, clearError: true));
    try {
      final posts = await _repo.list();
      if (!isClosed) {
        emit(state.copyWith(status: LoadStatus.ready, posts: posts));
      }
    } on ApiException catch (exception) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: LoadStatus.failed,
            error: _errorFor(exception),
          ),
        );
      }
    }
  }

  /// Sends a post; true when it was accepted, so the field can be cleared.
  Future<bool> post(PostKind kind, String text, {int? parentId}) async {
    final message = text.trim();
    if (state.busy) return false;
    if (_auth.session == null) {
      emit(state.copyWith(error: BoardroomError.signIn));
      return false;
    }
    if (message.length < (kind == PostKind.comment ? 1 : 3)) {
      emit(state.copyWith(error: BoardroomError.tooShort));
      return false;
    }
    return _run(() => _repo.submit(kind, message, parentId: parentId));
  }

  /// Admin only: makes a suggestion public or private again.
  Future<void> setPublic(int id, {required bool value}) =>
      _run(() => _repo.setPublic(id, value: value));

  /// Admin only: deletes a post or a comment.
  Future<void> delete(int id) => _run(() => _repo.delete(id));

  /// Runs a write, then reloads the posts; true on success.
  Future<bool> _run(Future<void> Function() action) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await action();
      emit(state.copyWith(status: LoadStatus.loading));
      final posts = await _repo.list();
      if (!isClosed) {
        emit(
          state.copyWith(busy: false, status: LoadStatus.ready, posts: posts),
        );
      }
      return true;
    } on ApiException catch (exception) {
      if (!isClosed) {
        emit(
          state.copyWith(
            busy: false,
            status: LoadStatus.ready,
            error: _errorFor(exception),
          ),
        );
      }
      return false;
    }
  }

  /// Maps a server error code to a [BoardroomError].
  BoardroomError _errorFor(ApiException exception) => switch (exception.code) {
    'invalid_message' => BoardroomError.tooShort,
    'rate_limited' => BoardroomError.rateLimited,
    'invalid_session' => BoardroomError.signIn,
    'forbidden' => BoardroomError.forbidden,
    _ => BoardroomError.network,
  };
}
