// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_link_button.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/post.dart';
import '../../../../l10n/l10n_extension.dart';
import 'delete_post.dart';
import 'post_meta.dart';

/// A comment under a post, with a delete link for admins.
class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.admin});

  final Post comment;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostMeta(post: comment, admin: admin),
        _message(sizes),
        if (admin) _delete(context),
      ],
    )
        .padding(left: sizes.gapSmall)
        .decorated(
          border: const Border(left: BorderSide(color: Retro.dim, width: 2)),
        )
        .padding(top: sizes.gapSmall);
  }

  /// The comment text.
  Widget _message(RetroSizes sizes) => Text(
    comment.message,
    style: retroBody(size: sizes.small),
  ).padding(top: sizes.gapSmall * 0.4);

  /// The admin delete link.
  Widget _delete(BuildContext context) => RetroLinkButton(
    context.l10n.boardroomDelete,
    color: Retro.red,
    onTap: () => confirmDeletePost(context, comment.id),
  );
}