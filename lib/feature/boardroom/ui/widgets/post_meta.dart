// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/utils/date_util.dart';
import '../../../../common/widgets/retro/controls/retro_tag.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/post.dart';
import '../../../../l10n/l10n_extension.dart';

/// Name, date and tags of a post or a comment.
class PostMeta extends StatelessWidget {
  const PostMeta({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    return Wrap(
      spacing: sizes.gapSmall,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${post.playerName}  ·  ${_when(context)}',
          style: retroBody(size: sizes.caption, color: Retro.orange),
        ),
        if (post.isAdmin) RetroTag(l10n.boardroomAdminTag),
        if (post.kind == PostKind.announcement)
          RetroTag(l10n.boardroomAnnouncementTag),
        if (post.kind == PostKind.suggestion) _visibilityTag(context),
      ],
    );
  }

  /// The post date in the player's language.
  String _when(BuildContext context) => formatDate(
    'd MMM, HH:mm',
    Localizations.localeOf(context).toString(),
    post.createdAt,
  );

  /// Public or private tag of a suggestion.
  Widget _visibilityTag(BuildContext context) {
    final l10n = context.l10n;
    return post.isPublic
        ? RetroTag(l10n.boardroomPublicTag, color: Colors.lightGreenAccent)
        : RetroTag(l10n.boardroomPrivateTag, color: Retro.dim);
  }
}
