// Package imports:
import 'package:equatable/equatable.dart';

/// The three kinds of post on the boardroom.
enum PostKind { announcement, suggestion, comment }

/// A boardroom post: an announcement, a suggestion or a comment (reply).
///
/// Announcements and suggestions carry their [comments]; a comment has none.
class Post extends Equatable {
  const Post({
    required this.id,
    required this.kind,
    required this.playerName,
    required this.message,
    required this.isPublic,
    required this.createdAt,
    required this.mine,
    required this.isAdmin,
    this.comments = const [],
  });

  final int id;
  final PostKind kind;
  final String playerName;
  final String message;

  /// Whether everyone can see it. Announcements are always public and a
  /// comment is visible whenever the post it belongs to is.
  final bool isPublic;
  final DateTime createdAt;

  /// True when the current player wrote it.
  final bool mine;

  /// True when an admin wrote it.
  final bool isAdmin;
  final List<Post> comments;

  @override
  List<Object?> get props => [
    id,
    kind,
    playerName,
    message,
    isPublic,
    createdAt,
    mine,
    isAdmin,
    comments,
  ];
}
