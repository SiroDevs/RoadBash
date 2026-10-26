// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/stats_models.dart';
import '../../../../l10n/gen/app_localizations.dart';
import 'range_labels.dart';

class StatsTable extends StatelessWidget {
  const StatsTable({super.key, required this.summary, required this.l10n});

  final StatsSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    final header = ['', l10n.statsVisitors, l10n.statsPlayers, l10n.statsGames];
    final body = <List<String>>[
      for (final range in StatsRange.values)
        if (summary.forDays(range.days) != null)
          [
            rangeLabel(l10n, range),
            '${summary.forDays(range.days)!.visitors}',
            '${summary.forDays(range.days)!.players}',
            '${summary.forDays(range.days)!.games}',
          ],
      [
        l10n.statsAllTime,
        '${summary.totalVisitors}',
        '${summary.totalPlayers}',
        '${summary.totalGames}',
      ],
    ];
    return Column(
      children: [
        _row(s, header, retroBody(size: s.caption, color: Retro.dim)),
        for (var i = 0; i < body.length; i++)
          _row(
            s,
            body[i],
            retroBody(
              size: s.small,
              color: i == body.length - 1 ? Retro.yellow : Colors.white,
            ),
          ),
      ],
    )
        .padding(all: s.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }

  Widget _row(RetroSizes s, List<String> cells, TextStyle style) => Row(
    children: [
      Text(cells[0], style: style).expanded(flex: 3),
      for (final c in cells.skip(1))
        Text(c, style: style, textAlign: TextAlign.right).expanded(flex: 2),
    ],
  ).padding(vertical: s.gapSmall * 0.5);
}
