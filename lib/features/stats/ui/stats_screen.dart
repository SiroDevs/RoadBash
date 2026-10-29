// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_chips.dart';
import '../../../common/widgets/retro/feedback/retro_status.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/load_status.dart';
import '../../../domain/models/stats_models.dart';
import '../cubit/stats_cubit.dart';
import 'widgets/bar_chart.dart';
import 'widgets/chart_skeleton.dart';
import 'widgets/heatmap.dart';
import 'widgets/range_labels.dart';
import 'widgets/stats_table.dart';

/// Stats screen showing totals, charts and the activity heatmap.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RetroPage(
      child: ResponsiveScrollBody(
        child: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, st) => RetroSubPage(
            title: context.l10n.statsTitle,
            maxWidth: 900,
            onBack: () => context.goNamed(RouteNames.reception),
            children: _body(context, st),
          ),
        ),
      ),
    );
  }

  /// Builds the stats content for the current state.
  List<Widget> _body(BuildContext context, StatsState st) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final summary = st.summary;
    if (st.status == LoadStatus.failed && summary == null) {
      return [RetroFailure(onRetry: context.read<StatsCubit>().load)];
    }
    if (summary == null) {
      return const [ChartSkeleton(panels: 4)];
    }
    final locale = Localizations.localeOf(context).toString();
    final labels = [
      for (final p in st.series) _stamp(st.range, p.time, locale),
    ];
    final gap = SizedBox(height: sizes.gap);
    return [
      Text(
        l10n.statsOnlineLine(summary.online, summary.onlinePlayers),
        style: retroBody(size: sizes.body, color: Colors.lightGreenAccent),
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
        const ChartSkeleton()
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

  /// Builds the heatmap section with its metric toggle.
  Widget _heatmap(BuildContext context, StatsState st, String locale) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.statsHeatmapTitle, style: retroBody(size: sizes.small)),
        SizedBox(height: sizes.gapSmall),
        RetroChips<HeatMetric>(
          items: {
            HeatMetric.visitors: l10n.statsVisitors,
            HeatMetric.players: l10n.statsPlayers,
          },
          selected: st.metric,
          onSelected: context.read<StatsCubit>().setMetric,
        ),
        SizedBox(height: sizes.gap),
        RetroHeatmap(
          cells: st.heat,
          metric: st.metric,
          dayLabels: [
            for (var i = 0; i < 7; i++)
              _short(_format('E', locale, DateTime(2024, 1, 1 + i))),
          ],
        ),
        SizedBox(height: sizes.gapSmall),
        Text(
          l10n.statsHeatmapNote,
          style: retroBody(size: sizes.caption, color: Retro.dim),
        ),
      ],
    )
        .padding(all: sizes.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }

  /// Shortens a day label to two characters.
  String _short(String text) =>
      text.length > 2 ? text.substring(0, 2) : text;

  /// Formats a bucket time for the selected range.
  String _stamp(StatsRange range, DateTime time, String locale) =>
      range == StatsRange.today
      ? _format('HH:mm', locale, time)
      : _format('d MMM', locale, time);

  /// Formats a date with a pattern, falling back if the locale is missing.
  String _format(String pattern, String locale, DateTime time) {
    try {
      return DateFormat(pattern, locale).format(time);
    } catch (_) {
      return DateFormat(pattern).format(time);
    }
  }
}
