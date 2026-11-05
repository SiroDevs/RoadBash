// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_chips.dart';
import '../../../common/widgets/retro/feedback/retro_status.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/leaderboard_entry.dart';
import '../../../domain/models/load_status.dart';
import '../../../l10n/l10n_extension.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/leaderboard_cubit.dart';
import 'leaderboard_skeleton.dart';

/// Leaderboard screen listing the top players.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final me = context.select<AuthCubit, String>(
      (c) => c.state.session?.name.toLowerCase() ?? '',
    );
    return RetroPage.gray(
      child: ResponsiveScrollBody(
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, st) => RetroSubPage(
            title: l10n.leaderboardTitle,
            maxWidth: 1100,
            onBack: () => context.goNamed(RouteNames.reception),
            children: _body(context, st, me),
          ),
        ),
      ),
    );
  }

  /// Builds the period tabs, the dates they cover and the table.
  List<Widget> _body(BuildContext context, LeaderboardState st, String me) {
    final sizes = context.sizes;
    final range = _range(context, st);
    return [
      RetroChips<LeaderboardPeriod>(
        items: {
          LeaderboardPeriod.thisWeek: context.l10n.leaderboardThisWeek,
          LeaderboardPeriod.lastWeek: context.l10n.leaderboardLastWeek,
          LeaderboardPeriod.allTime: context.l10n.leaderboardAllTime,
        },
        selected: st.period,
        onSelected: context.read<LeaderboardCubit>().setPeriod,
      ),
      if (range != null)
        Text(range, style: retroBody(size: sizes.caption, color: Retro.dim)),
      ..._table(context, st, me),
    ];
  }

  /// Returns the dates a week's leaderboard covers, or null for all time.
  String? _range(BuildContext context, LeaderboardState st) {
    final from = st.from;
    final to = st.to;
    if (from == null || to == null) return null;
    final locale = Localizations.localeOf(context).toString();
    String day(DateTime time) {
      try {
        return DateFormat('d MMM', locale).format(time);
      } catch (_) {
        return DateFormat('d MMM').format(time);
      }
    }

    final last = to.toUtc().subtract(const Duration(days: 1));
    return context.l10n.leaderboardRange(day(from.toUtc()), day(last));
  }

  /// Builds the leaderboard table for the current load status.
  List<Widget> _table(BuildContext context, LeaderboardState st, String me) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    switch (st.status) {
      case LoadStatus.loading:
        return const [LeaderboardSkeleton()];
      case LoadStatus.failed:
        return [RetroFailure(onRetry: context.read<LeaderboardCubit>().load)];
      case LoadStatus.ready:
        if (st.entries.isEmpty) {
          return [Text(l10n.leaderboardEmpty, style: retroBody(size: sizes.body))];
        }
        return [
          Column(
            children: [
              _row(
                sizes,
                '#',
                l10n.leaderboardPlayer,
                l10n.leaderboardGames,
                l10n.leaderboardWins,
                retroBody(size: sizes.caption, color: Retro.dim),
              ),
              for (final e in st.entries) _entry(sizes, e, e.name.toLowerCase() == me),
            ],
          )
              .padding(all: sizes.gap)
              .decorated(
                color: Retro.panel,
                borderRadius: BorderRadius.circular(12),
              ),
        ];
    }
  }

  /// Builds one leaderboard row; highlights the current player.
  Widget _entry(RetroSizes sizes, LeaderboardEntry entry, bool mine) => _row(
    sizes,
    '${entry.rank}',
    entry.name,
    '${entry.games}',
    '${entry.wins}',
    retroBody(
      size: sizes.body,
      color: mine ? Retro.yellow : Colors.white,
    ).copyWith(fontFamily: AppConstants.displayFont, fontWeight: FontWeight.w400),
  );

  /// Builds a row of rank, name, games and wins cells.
  ///
  /// All cells share [style] and the column widths from [sizes].
  Widget _row(
    RetroSizes sizes,
    String rank,
    String name,
    String games,
    String wins,
    TextStyle style,
  ) => Row(
    children: [
      Text(rank, style: style).width(sizes.resultPlaceW),
      Text(name, style: style, overflow: TextOverflow.ellipsis).expanded(),
      Text(games, style: style, textAlign: TextAlign.right)
          .width(sizes.resultTimeW * 0.9),
      Text(wins, style: style, textAlign: TextAlign.right)
          .width(sizes.resultTimeW * 0.8),
    ],
  ).padding(vertical: sizes.gapSmall * 0.5);
}
