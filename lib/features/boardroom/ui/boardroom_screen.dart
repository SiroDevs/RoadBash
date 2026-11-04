// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_send_box.dart';
import '../../../common/widgets/retro/feedback/retro_status.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/models/post.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/boardroom_cubit.dart';
import 'boardroom_labels.dart';
import 'widgets/boardroom_skeleton.dart';
import 'widgets/boardroom_tabs.dart';
import 'widgets/post_card.dart';

/// The boardroom: announcements, suggestions and the comments under them.
class BoardroomScreen extends StatelessWidget {
  const BoardroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RetroPage.gray(
      child: ResponsiveScrollBody(
        child: BlocBuilder<BoardroomCubit, BoardroomState>(
          builder: (context, state) => RetroSubPage(
            title: context.l10n.boardroomTitle,
            maxWidth: 1100,
            onBack: () => context.goNamed(RouteNames.menu),
            children: _body(context, state),
          ),
        ),
      ),
    );
  }

  /// Builds the strips, the hint, the compose box and the posts.
  List<Widget> _body(BuildContext context, BoardroomState state) {
    final cubit = context.read<BoardroomCubit>();
    return [
      BoardroomTabs(
        selected: state.tab,
        onSelected: cubit.setTab,
        onRefresh: cubit.load,
      ),
      _hint(context, state),
      if (state.canCompose) _composer(context, state),
      if (state.error != null) _error(context, state.error!),
      ..._posts(context, state),
    ];
  }

  /// The hint text under the strips.
  Widget _hint(BuildContext context, BoardroomState state) {
    final sizes = context.sizes;
    return Text(
      boardroomHint(context.l10n, state),
      style: retroBody(size: sizes.small),
    ).padding(vertical: sizes.gap);
  }

  /// The compose box for the selected strip.
  Widget _composer(BuildContext context, BoardroomState state) {
    final l10n = context.l10n;
    final cubit = context.read<BoardroomCubit>();
    final announcing = state.tabKind == PostKind.announcement;
    return RetroSendBox(
      key: ValueKey(state.tab),
      label: announcing
          ? l10n.boardroomAnnouncementLabel
          : l10n.boardroomSuggestionLabel,
      sendLabel: announcing ? l10n.boardroomAnnounce : l10n.boardroomSend,
      maxLines: 4,
      onSend: (text) => cubit.post(state.tabKind, text),
    ).padding(bottom: context.sizes.gap);
  }

  /// The last error as a red line.
  Widget _error(BuildContext context, BoardroomError error) {
    final sizes = context.sizes;
    return Text(
      boardroomErrorText(context.l10n, error),
      style: retroBody(size: sizes.small, color: Retro.red),
    ).padding(bottom: sizes.gapSmall);
  }

  /// The posts of the selected strip for the current load status.
  List<Widget> _posts(BuildContext context, BoardroomState state) {
    if (state.status == LoadStatus.loading) return [const BoardroomSkeleton()];
    if (state.status == LoadStatus.failed &&
        state.error != BoardroomError.signIn) {
      return [RetroFailure(onRetry: context.read<BoardroomCubit>().load)];
    }
    if (state.shownPosts.isEmpty) return [_empty(context)];
    return [
      for (final post in state.shownPosts)
        PostCard(key: ValueKey(post.id), post: post, admin: state.admin),
    ];
  }

  /// The line shown when the strip has no posts.
  Widget _empty(BuildContext context) => Text(
    context.l10n.boardroomEmpty,
    style: retroBody(size: context.sizes.small),
  );
}
