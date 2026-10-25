// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/app_router/route_names.dart';
import '../../../common/constants/app_assets.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/retro_chips.dart';
import '../../../common/widgets/retro/retro_controls.dart';
import '../../../common/widgets/retro/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/music_scope.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/models/stats_models.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/stats_cubit.dart';
import 'widgets/bar_chart.dart';
import 'widgets/heatmap.dart';
import 'widgets/range_labels.dart';
import 'widgets/stats_table.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.sizes;
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        asset: AppAssets.appMain,
        child: ResponsiveScrollBody(
          child: BlocBuilder<StatsCubit, StatsState>(
            builder: (context, st) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RetroTitle(l10n.statsTitle).expanded(),
                    RetroButton(
                      l10n.commonBack,
                      onTap: () => context.goNamed(RouteNames.reception),
                    ),
                  ],
                ),
                SizedBox(height: s.gap),
                ..._body(context, st),
              ],
            ).constrained(maxWidth: 900).alignment(Alignment.topCenter),
          ),
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, StatsState st) {
    final l10n = context.l10n;
    final s = context.sizes;
    final summary = st.summary;
    if (st.status == LoadStatus.failed && summary == null) {
      return [
        Text(l10n.errNetwork, style: retroBody(size: s.body, color: Retro.red)),
        SizedBox(height: s.gap),
        RetroButton(l10n.commonRetry, onTap: context.read<StatsCubit>().load),
      ];
    }
    if (summary == null) {
      return [const CircularProgressIndicator(color: Retro.orange).center()];
    }
    final locale = Localizations.localeOf(context).toString();
    final labels = [
      for (final p in st.series) _stamp(st.range, p.time, locale),
    ];
    final gap = SizedBox(height: s.gap);
    return [
      Text(
        l10n.statsOnlineLine(summary.online, summary.onlinePlayers),
        style: retroBody(size: s.body, color: Colors.lightGreenAccent),
      ),
      gap,
      StatsTable(summary: summary, l10n: l10n),
      gap,
      RetroChips<StatsRange>(
        items: {for (final r in StatsRange.values) r: rangeLabel(l10n, r)},
        selected: st.range,
        onSelected: context.read<StatsCubit>().setRange,
      ),
      gap,
      if (st.status == LoadStatus.loading)
        const LinearProgressIndicator(color: Retro.orange)
      else ...[
        RetroBarChart(
          title: l10n.statsVisitors,
          values: [for (final p in st.series) p.visitors],
          labels: labels,
        ),
        gap,
        RetroBarChart(
          title: l10n.statsPlayers,
          values: [for (final p in st.series) p.players],
          labels: labels,
          color: Retro.yellow,
        ),
        gap,
        RetroBarChart(
          title: l10n.statsGames,
          values: [for (final p in st.series) p.games],
          labels: labels,
          color: Colors.lightBlueAccent,
        ),
        gap,
        _heatmap(context, st, locale),
      ],
      gap,
    ];
  }

  Widget _heatmap(BuildContext context, StatsState st, String locale) {
    final l10n = context.l10n;
    final s = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.statsHeatmapTitle, style: retroBody(size: s.small)),
        SizedBox(height: s.gapSmall),
        RetroChips<HeatMetric>(
          items: {
            HeatMetric.visitors: l10n.statsVisitors,
            HeatMetric.players: l10n.statsPlayers,
          },
          selected: st.metric,
          onSelected: context.read<StatsCubit>().setMetric,
        ),
        SizedBox(height: s.gap),
        RetroHeatmap(
          cells: st.heat,
          metric: st.metric,
          dayLabels: [
            for (var i = 0; i < 7; i++)
              _short(_format('E', locale, DateTime(2024, 1, 1 + i))),
          ],
        ),
        SizedBox(height: s.gapSmall),
        Text(
          l10n.statsHeatmapNote,
          style: retroBody(size: s.caption, color: Retro.dim),
        ),
      ],
    )
        .padding(all: s.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }

  String _short(String text) =>
      text.length > 2 ? text.substring(0, 2) : text;

  String _stamp(StatsRange range, DateTime t, String locale) =>
      range == StatsRange.today
      ? _format('HH:mm', locale, t)
      : _format('d MMM', locale, t);

  String _format(String pattern, String locale, DateTime t) {
    try {
      return DateFormat(pattern, locale).format(t);
    } catch (_) {
      return DateFormat(pattern).format(t);
    }
  }
}
