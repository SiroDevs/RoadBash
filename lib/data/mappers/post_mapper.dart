// Project imports:
import '../../domain/models/post.dart';

/// Builds a [Post] from JSON. A comment has no `kind` or `is_public` in the
/// payload, so it falls back to [PostKind.comment] and public.
Post postFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num).toInt(),
  kind: PostKind.values.asNameMap()[json['kind']] ?? PostKind.comment,
  playerName: json['player_name'] as String,
  message: json['message'] as String,
  isPublic: json['is_public'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
  mine: json['mine'] as bool? ?? false,
  isAdmin: json['is_admin'] as bool? ?? false,
  comments: [
    for (final c in (json['comments'] as List?) ?? const [])
      postFromJson(Map<String, dynamic>.from(c as Map)),
  ],
);
