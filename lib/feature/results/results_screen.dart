// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import '../../common/layout/responsive_scroll_body.dart';
import '../../common/layout/retro_sizes.dart';
import '../../common/widgets/retro/controls/retro_controls.dart';
import '../../common/widgets/retro/page/retro_page.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/game/race/race_result.dart';
import '../../core/router/route_names.dart';
import '../../l10n/l10n_extension.dart';
import '../../common/utils/money_util.dart';
import '../race/cubit/race_cubit.dart';
import 'widgets/results_money.dart';

/// Results screen shown after a race.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.outcome});

  final RaceOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = outcome.result;
    final rows = result.rows;
    final sizes = context.sizes;
    return RetroPage.gray(
      child: ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroTitle(_title(context)),
                SizedBox(height: sizes.gap * 1.2),
                if (result.busted) ...[
                  Text(
                    l10n.bustedNote,
                    style: retroBody(size: sizes.body, color: Colors.white),
                  ),
                  SizedBox(height: sizes.gap * 0.75),
                  Text(
                    l10n.bustedFine(groupThousands(result.fine)),
                    style: retroBody(size: sizes.body, color: Retro.yellow),
                  ),
                ] else if (result.crashed)
                  Text(
                    l10n.crashedNote(result.crashKmh),
                    style: retroBody(size: sizes.body, color: Colors.white),
                  )
                else
                  for (final r in rows) _row(context, r),
                const ResultsMoney(),
                if (outcome.newBest && !result.busted && !result.crashed) ...[
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

  /// The title: busted, crashed or the plain results title.
  String _title(BuildContext context) {
    final l10n = context.l10n;
    if (outcome.result.busted) return l10n.hudBusted;
    if (outcome.result.crashed) return l10n.hudCrashed;
    return l10n.resultsTitle;
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
