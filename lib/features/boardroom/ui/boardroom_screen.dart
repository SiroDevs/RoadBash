// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/constants/app_assets.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/click_sound.dart';
import '../../../common/widgets/retro/controls/retro_chips.dart';
import '../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../common/widgets/retro/controls/retro_field.dart';
import '../../../common/widgets/retro/feedback/retro_status.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/models/post.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/boardroom_cubit.dart';

/// The boardroom: announcements from the admins, suggestions from players
/// and the comments under them.
class BoardroomScreen extends StatelessWidget {
  const BoardroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RetroPage(
      asset: AppAssets.appMain,
      grayscale: true,
      dim: 0.55,
      child: ResponsiveScrollBody(
        child: BlocBuilder<BoardroomCubit, BoardroomState>(
          builder: (context, st) => RetroSubPage(
            title: context.l10n.boardroomTitle,
            maxWidth: 1100,
            onBack: () => context.goNamed(RouteNames.menu),
            children: _body(context, st),
          ),
        ),
      ),
    );
  }

  /// Builds the composer, the error line and the list of posts.
  List<Widget> _body(BuildContext context, BoardroomState st) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final error = _errorText(l10n, st.error);
    final cubit = context.read<BoardroomCubit>();
    final announcements = st.tab == BoardroomTab.announcements;
    // Admins write announcements, players write suggestions; nobody writes
    // the other kind, so that strip has no composer.
    final canCompose = announcements ? st.admin : !st.admin;
    final hint = switch ((announcements, st.admin)) {
      (true, true) => l10n.boardroomAdminAnnounceHint,
      (true, false) => l10n.boardroomAnnouncementsHint,
      (false, true) => l10n.boardroomAdminHint,
      (false, false) => l10n.boardroomHint,
    };
    return [
      Row(
        children: [
          RetroChips<BoardroomTab>(
            items: {
              BoardroomTab.announcements: l10n.boardroomAnnouncements,
              BoardroomTab.suggestions: l10n.boardroomSuggestions,
            },
            selected: st.tab,
            onSelected: cubit.setTab,
          ).expanded(),
          RetroButton(l10n.commonRefresh, onTap: cubit.load),
        ],
      ),
      SizedBox(height: sizes.gap),
      Text(hint, style: retroBody(size: sizes.small)),
      SizedBox(height: sizes.gap),
      if (canCompose) ...[
        _Composer(
          // A new key per strip, so a half-written text is not carried over.
          key: ValueKey(st.tab),
          kind: announcements ? PostKind.announcement : PostKind.suggestion,
          label: announcements
              ? l10n.boardroomAnnouncementLabel
              : l10n.boardroomSuggestionLabel,
          send: announcements ? l10n.boardroomAnnounce : l10n.boardroomSend,
          lines: 4,
        ),
        SizedBox(height: sizes.gap),
      ],
      if (error != null)
        Text(error, style: retroBody(size: sizes.small, color: Retro.red))
            .padding(bottom: sizes.gapSmall),
      if (st.busy)
        const LinearProgressIndicator(color: Retro.orange)
            .padding(bottom: sizes.gapSmall),
      ..._posts(context, st),
    ];
  }

  /// Builds the post list for the current load status.
  List<Widget> _posts(BuildContext context, BoardroomState st) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    if (st.status == LoadStatus.loading && st.posts.isEmpty) {
      return const [SizedBox(height: 60, child: RetroLoading())];
    }
    if (st.status == LoadStatus.failed && st.error != BoardroomError.signIn) {
      return [RetroFailure(onRetry: context.read<BoardroomCubit>().load)];
    }
    final kind = st.tab == BoardroomTab.announcements
        ? PostKind.announcement
        : PostKind.suggestion;
    final shown = [
      for (final post in st.posts)
        if (post.kind == kind) post,
    ];
    if (shown.isEmpty) {
      return [Text(l10n.boardroomEmpty, style: retroBody(size: sizes.small))];
    }
    return [
      for (final post in shown)
        _PostCard(key: ValueKey(post.id), post: post, admin: st.admin),
    ];
  }
}

/// Returns the localized text for a boardroom error.
String? _errorText(AppLocalizations l10n, BoardroomError? error) =>
    switch (error) {
      null => null,
      BoardroomError.tooShort => l10n.boardroomTooShort,
      BoardroomError.rateLimited => l10n.boardroomRateLimited,
      BoardroomError.signIn => l10n.boardroomSignIn,
      BoardroomError.forbidden => l10n.boardroomForbidden,
      BoardroomError.network => l10n.errNetwork,
    };

/// A text field with a send button. Clears itself once the post went through.
class _Composer extends StatefulWidget {
  const _Composer({
    super.key,
    required this.kind,
    required this.label,
    required this.send,
    this.parentId,
    this.lines = 3,
  });

  final PostKind kind;
  final String label;
  final String send;
  final int? parentId;
  final int lines;

  @override
  State<_Composer> createState() => _ComposerState();
}

/// State for [_Composer]; owns the text controller.
class _ComposerState extends State<_Composer> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Sends the text and clears the field when it was accepted.
  Future<void> _send() async {
    final cubit = context.read<BoardroomCubit>();
    if (cubit.state.busy) return;
    final sent = await cubit.post(
      widget.kind,
      _text.text,
      parentId: widget.parentId,
    );
    if (sent && mounted) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroField(
          controller: _text,
          label: widget.label,
          maxLength: 1000,
          maxLines: widget.lines,
          action: TextInputAction.newline,
        ),
        SizedBox(height: sizes.gapSmall),
        RetroButton(widget.send, onTap: _send),
      ],
    );
  }
}

/// One announcement or suggestion with its comments and admin actions.
class _PostCard extends StatefulWidget {
  const _PostCard({super.key, required this.post, required this.admin});

  final Post post;
  final bool admin;

  @override
  State<_PostCard> createState() => _PostCardState();
}

/// State for [_PostCard]; tracks whether the reply field is open.
class _PostCardState extends State<_PostCard> {
  bool _replying = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final cubit = context.read<BoardroomCubit>();
    final post = widget.post;
    final admin = widget.admin;
    // Replies are open on public posts; only admins can reply to a private one.
    final canReply = post.isPublic || admin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(post: post),
        SizedBox(height: sizes.gapSmall * 0.5),
        Text(post.message, style: retroBody(size: sizes.small)),
        for (final comment in post.comments)
          _CommentTile(comment: comment, admin: admin),
        SizedBox(height: sizes.gapSmall),
        Wrap(
          spacing: sizes.gap,
          runSpacing: sizes.gapSmall,
          children: [
            if (canReply)
              _LinkButton(
                label: _replying ? l10n.commonCancel : l10n.boardroomReply,
                onTap: () => setState(() => _replying = !_replying),
              ),
            if (admin && post.kind == PostKind.suggestion)
              _LinkButton(
                label: post.isPublic
                    ? l10n.boardroomMakePrivate
                    : l10n.boardroomMakePublic,
                onTap: () => cubit.setPublic(post.id, value: !post.isPublic),
              ),
            if (admin)
              _LinkButton(
                label: l10n.boardroomDelete,
                color: Retro.red,
                onTap: () => _confirmDelete(context, post.id),
              ),
          ],
        ),
        if (_replying && canReply) ...[
          SizedBox(height: sizes.gapSmall),
          _Composer(
            kind: PostKind.comment,
            parentId: post.id,
            label: l10n.boardroomReplyLabel,
            send: l10n.boardroomReply,
          ),
        ],
      ],
    )
        .padding(all: sizes.gap)
        .decorated(
          color: const Color(0x66000000),
          borderRadius: BorderRadius.circular(10),
        )
        .padding(bottom: sizes.gapSmall);
  }
}

/// Name, date and tags of a post.
class _Header extends StatelessWidget {
  const _Header({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final when = DateFormat('d MMM, HH:mm').format(post.createdAt);
    return Wrap(
      spacing: sizes.gapSmall,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${post.playerName}  ·  $when',
          style: retroBody(size: sizes.caption, color: Retro.orange),
        ),
        if (post.isAdmin) _tag(sizes, l10n.boardroomAdminTag, Retro.yellow),
        if (post.kind == PostKind.announcement)
          _tag(sizes, l10n.boardroomAnnouncementTag, Retro.yellow),
        if (post.kind == PostKind.suggestion)
          post.isPublic
              ? _tag(sizes, l10n.boardroomPublicTag, Colors.lightGreenAccent)
              : _tag(sizes, l10n.boardroomPrivateTag, Retro.dim),
      ],
    );
  }

  /// A small upper-case tag.
  Widget _tag(RetroSizes sizes, String text, Color color) => Text(
    text.toUpperCase(),
    style: retroBody(size: sizes.caption * 0.8, color: color),
  );
}

/// A comment under a post, with a delete link for admins.
class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.admin});

  final Post comment;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final when = DateFormat('d MMM, HH:mm').format(comment.createdAt);
    return Container(
      margin: EdgeInsets.only(top: sizes.gapSmall),
      padding: EdgeInsets.only(left: sizes.gapSmall),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Retro.dim, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: sizes.gapSmall,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${comment.playerName}  ·  $when',
                style: retroBody(size: sizes.caption, color: Retro.orange),
              ),
              if (comment.isAdmin)
                Text(
                  l10n.boardroomAdminTag.toUpperCase(),
                  style: retroBody(size: sizes.caption * 0.8, color: Retro.yellow),
                ),
            ],
          ),
          SizedBox(height: sizes.gapSmall * 0.4),
          Text(comment.message, style: retroBody(size: sizes.small)),
          if (admin)
            _LinkButton(
              label: l10n.boardroomDelete,
              color: Retro.red,
              onTap: () => _confirmDelete(context, comment.id),
            ).padding(top: sizes.gapSmall * 0.5),
        ],
      ),
    );
  }
}

/// A tappable text link that plays the click sound.
class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.onTap,
    this.color = Retro.orange,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      playClick(context);
      onTap();
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: context.sizes.gapSmall * 0.4),
      child: Text(
        label.toUpperCase(),
        style: retroBody(size: context.sizes.caption, color: color),
      ),
    ),
  );
}

/// Asks before deleting a post or comment, then deletes it.
Future<void> _confirmDelete(BuildContext context, int id) async {
  final l10n = context.l10n;
  final sizes = context.sizes;
  final cubit = context.read<BoardroomCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: Retro.panel,
      title: Text(
        l10n.boardroomDeleteTitle,
        style: retroBody(size: sizes.body, color: Retro.yellow),
      ),
      content: Text(
        l10n.boardroomDeleteBody,
        style: retroBody(size: sizes.small),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(
            l10n.commonCancel,
            style: retroBody(size: sizes.small, color: Retro.dim),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          child: Text(
            l10n.boardroomDelete,
            style: retroBody(size: sizes.small, color: Retro.red),
          ),
        ),
      ],
    ),
  );
  if (confirmed ?? false) await cubit.delete(id);
}
