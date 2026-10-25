// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/app_router/route_names.dart';
import '../../../common/constants/app_assets.dart';
import '../../../common/constants/app_constants.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/retro_controls.dart';
import '../../../common/widgets/retro/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/music_scope.dart';
import '../../../core/auth/auth_cubit.dart';
import '../../../domain/models/leaderboard_entry.dart';
import '../../../domain/models/load_status.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/leaderboard_cubit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.sizes;
    final me = context.select<AuthCubit, String>(
      (c) => c.state.session?.name.toLowerCase() ?? '',
    );
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        asset: AppAssets.appMain,
        child: ResponsiveScrollBody(
          child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
            builder: (context, st) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RetroTitle(l10n.leaderboardTitle).expanded(),
                    RetroButton(
                      l10n.commonBack,
                      onTap: () => context.goNamed(RouteNames.reception),
                    ),
                  ],
                ),
                SizedBox(height: s.gap),
                ..._body(context, st, me),
              ],
            ).constrained(maxWidth: 700).alignment(Alignment.topCenter),
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
        return [const CircularProgressIndicator(color: Retro.orange).center()];
      case LoadStatus.failed:
        return [
          Text(l10n.errNetwork, style: retroBody(size: s.body, color: Retro.red)),
          SizedBox(height: s.gap),
          RetroButton(
            l10n.commonRetry,
            onTap: context.read<LeaderboardCubit>().load,
          ),
        ];
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
