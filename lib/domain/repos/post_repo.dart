// Project imports:
import '../models/post.dart';

/// Contract for reading and writing boardroom posts.
abstract interface class PostRepo {
  /// Sends a post; [parentId] is the post a comment replies to.
  Future<void> submit(PostKind kind, String message, {int? parentId});

  /// Loads the posts the current player may see, with their comments.
  Future<List<Post>> list();

  /// Admin only: shows or hides a suggestion.
  Future<void> setPublic(int id, {required bool value});

  /// Admin only: deletes a post and the comments under it.
  Future<void> delete(int id);
}
