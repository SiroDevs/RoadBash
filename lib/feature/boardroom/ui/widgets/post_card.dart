// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_link_button.dart';
import '../../../../common/widgets/retro/controls/retro_send_box.dart';
import '../../../../common/widgets/retro/retro_card.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/post.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/boardroom_cubit.dart';
import 'comment_tile.dart';
import 'delete_post.dart';
import 'post_meta.dart';

/// An announcement or suggestion with its comments and admin actions.
class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, required this.admin});

  final Post post;
  final bool admin;

  @override
  State<PostCard> createState() => _PostCardState();
}

/// State for [PostCard]; tracks whether the reply box is open.
class _PostCardState extends State<PostCard> {
  bool _replying = false;

  /// Public posts take replies from anyone; private ones only from admins.
  bool get _repliesOpen => widget.post.isPublic || widget.admin;

  @override
  Widget build(BuildContext context) {
    return RetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostMeta(post: widget.post, admin: widget.admin),
          _message(context),
          ..._comments(),
          _actions(context),
          if (_replying && _repliesOpen) _replyBox(context),
        ],
      ),
    ).padding(bottom: context.sizes.gapSmall);
  }

  /// The post text.
  Widget _message(BuildContext context) => Text(
    widget.post.message,
    style: retroBody(size: context.sizes.small),
  ).padding(top: context.sizes.gapSmall * 0.5);

  /// The comments under the post.
  List<Widget> _comments() => [
    for (final comment in widget.post.comments)
      CommentTile(comment: comment, admin: widget.admin),
  ];

  /// Reply, publish and delete links.
  Widget _actions(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final post = widget.post;
    final cubit = context.read<BoardroomCubit>();
    return Wrap(
      spacing: sizes.gap,
      children: [
        if (_repliesOpen) RetroLinkButton(_replyLabel(l10n), onTap: _toggleReply),
        if (widget.admin && post.kind == PostKind.suggestion)
          RetroLinkButton(
            post.isPublic ? l10n.boardroomMakePrivate : l10n.boardroomMakePublic,
            onTap: () => cubit.setPublic(post.id, value: !post.isPublic),
          ),
        if (widget.admin)
          RetroLinkButton(
            l10n.boardroomDelete,
            color: Retro.red,
            onTap: () => confirmDeletePost(context, post.id),
          ),
      ],
    ).padding(top: sizes.gapSmall);
  }

  /// The reply box under the post.
  Widget _replyBox(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<BoardroomCubit>();
    return RetroSendBox(
      label: l10n.boardroomReplyLabel,
      sendLabel: l10n.boardroomReply,
      onSend: (text) =>
          cubit.post(PostKind.comment, text, parentId: widget.post.id),
    ).padding(top: context.sizes.gapSmall);
  }

  /// Reply or cancel, depending on whether the box is open.
  String _replyLabel(AppLocalizations l10n) =>
      _replying ? l10n.commonCancel : l10n.boardroomReply;

  /// Opens or closes the reply box.
  void _toggleReply() => setState(() => _replying = !_replying);
}