// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/post.dart';
import '../../domain/repos/post_repo.dart';
import '../mappers/post_mapper.dart';
import '../sources/remote/api_client.dart';

/// Reads and writes boardroom posts through the API.
@LazySingleton(as: PostRepo)
class PostRepoImpl implements PostRepo {
  PostRepoImpl(this._api);

  final ApiClient _api;

  @override
  Future<void> submit(PostKind kind, String message, {int? parentId}) =>
      _api.callAuthed('rb_submit_post', {
        'p_kind': kind.name,
        'p_message': message,
        'p_parent_id': parentId,
      });

  @override
  Future<List<Post>> list() async =>
      (await _api.callAuthed('rb_list_posts')).rows(postFromJson);

  @override
  Future<void> setPublic(int id, {required bool value}) => _api.callAuthed(
    'rb_set_post_public',
    {'p_post_id': id, 'p_public': value},
  );

  @override
  Future<void> delete(int id) =>
      _api.callAuthed('rb_delete_post', {'p_post_id': id});
}
