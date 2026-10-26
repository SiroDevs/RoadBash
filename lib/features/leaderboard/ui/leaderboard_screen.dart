// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/router/route_names.dart';
import '../../../core/constants/app_constants.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/feedback/retro_status.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../../domain/models/leaderboard_entry.dart';
import '../../../domain/models/load_status.dart';
import '../../../common/l10n/l10n_extension.dart';
import '../cubit/leaderboard_cubit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final me = context.select<AuthCubit, String>(
      (c) => c.state.session?.name.toLowerCase() ?? '',
    );
    return RetroPage(
      child: ResponsiveScrollBody(
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, st) => RetroSubPage(
            title: l10n.leaderboardTitle,
            maxWidth: 700,
            onBack: () => context.goNamed(RouteNames.reception),
            children: _body(context, st, me),
          ),
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, LeaderboardState st, String me) {
    final l10n = context.l10n;
    final s = context.sizes;
    switch (st.status) {
      case LoadStatus.loading:
        return const [RetroLoading()];
      case LoadStatus.failed:
        return [RetroFailure(onRetry: context.read<LeaderboardCubit>().load)];
      case LoadStatus.ready:
        if (st.entries.isEmpty) {
          return [Text(l10n.leaderboardEmpty, style: retroBody(size: s.body))];
        }
        return [
          Column(
            children: [
              _row(
                s,
                '#',
                l10n.leaderboardPlayer,
                l10n.leaderboardGames,
                l10n.leaderboardWins,
                retroBody(size: s.caption, color: Retro.dim),
              ),
              for (final e in st.entries) _entry(s, e, e.name.toLowerCase() == me),
            ],
          )
              .padding(all: s.gap)
              .decorated(
                color: Retro.panel,
                borderRadius: BorderRadius.circular(12),
              ),
        ];
    }
  }

  Widget _entry(RetroSizes s, LeaderboardEntry e, bool mine) => _row(
    s,
    '${e.rank}',
    e.name,
    '${e.games}',
    '${e.wins}',
    retroBody(
      size: s.body,
      color: mine ? Retro.yellow : Colors.white,
    ).copyWith(fontFamily: AppConstants.displayFont, fontWeight: FontWeight.w400),
  );

  Widget _row(
    RetroSizes s,
    String rank,
    String name,
    String games,
    String wins,
    TextStyle style,
  ) => Row(
    children: [
      Text(rank, style: style).width(s.resultPlaceW),
      Text(name, style: style, overflow: TextOverflow.ellipsis).expanded(),
      Text(games, style: style, textAlign: TextAlign.right)
          .width(s.resultTimeW * 0.9),
      Text(wins, style: style, textAlign: TextAlign.right)
          .width(s.resultTimeW * 0.8),
    ],
  ).padding(vertical: s.gapSmall * 0.5);
}
