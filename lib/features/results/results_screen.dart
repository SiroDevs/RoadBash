// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/l10n/l10n_extension.dart';
import '../../common/layout/responsive_scroll_body.dart';
import '../../common/layout/retro_sizes.dart';
import '../../common/widgets/retro/controls/retro_controls.dart';
import '../../common/widgets/retro/page/retro_page.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/constants/app_constants.dart';
import '../../core/game/race/race_result.dart';
import '../../core/router/route_names.dart';
import '../race/cubit/race_cubit.dart';

/// Results screen shown after a race.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.outcome});

  final RaceOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = outcome.result;
    final rows = [
      ...result.rows.take(3),
      if (result.player.place > 3) result.player,
    ];
    final sizes = context.sizes;
    return RetroPage(
      child: ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroTitle(l10n.resultsTitle),
                SizedBox(height: sizes.gap * 1.2),
                for (final r in rows) _row(context, r),
                if (outcome.newBest) ...[
                  SizedBox(height: sizes.gap * 0.75),
                  Text(
                    l10n.newBestTime,
                    style: retroBody(size: sizes.body, color: Retro.yellow),
                  ),
                ],
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: sizes.gap),
              child: Wrap(
                spacing: sizes.gap * 0.75,
                runSpacing: sizes.gap * 0.75,
                children: [
                  RetroButton(
                    l10n.raceAgain,
                    onTap: () => context.goNamed(
                      RouteNames.race,
                      pathParameters: {'scene': result.scene.name},
                    ),
                  ),
                  RetroButton(
                    l10n.backToMenu,
                    onTap: () => context.goNamed(RouteNames.menu),
                  ),
                  RetroButton(
                    l10n.receptionTitle,
                    onTap: () => context.goNamed(RouteNames.reception),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds one result row for a racer.
  Widget _row(BuildContext context, ResultRow row) {
    final sizes = context.sizes;
    final style = retroBody(
      size: sizes.resultRow,
      color: row.isPlayer ? Retro.yellow : Colors.white,
    ).copyWith(fontFamily: AppConstants.displayFont, fontWeight: FontWeight.w400);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizes.gapSmall * 0.5),
      child: Row(
        children: [
          SizedBox(width: sizes.resultPlaceW, child: Text('${row.place})', style: style)),
          SizedBox(
            width: sizes.resultTimeW,
            child: Text(formatTime(row.seconds), style: style),
          ),
          Expanded(
            child: Text(row.name, style: style, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
