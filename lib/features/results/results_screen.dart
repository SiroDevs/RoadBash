// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../core/router/route_names.dart';
import '../../core/constants/app_constants.dart';
import '../../common/layout/responsive_scroll_body.dart';
import '../../common/layout/retro_sizes.dart';
import '../../common/widgets/retro/controls/retro_controls.dart';
import '../../common/widgets/retro/page/retro_page.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/game/race/race_result.dart';
import '../../common/l10n/l10n_extension.dart';
import '../race/cubit/race_cubit.dart';

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
    final s = context.sizes;
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
                SizedBox(height: s.gap * 1.2),
                for (final r in rows) _row(context, r),
                if (outcome.newBest) ...[
                  SizedBox(height: s.gap * 0.75),
                  Text(
                    l10n.newBestTime,
                    style: retroBody(size: s.body, color: Retro.yellow),
                  ),
                ],
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: s.gap),
              child: Wrap(
                spacing: s.gap * 0.75,
                runSpacing: s.gap * 0.75,
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

  Widget _row(BuildContext context, ResultRow r) {
    final s = context.sizes;
    final style = retroBody(
      size: s.resultRow,
      color: r.isPlayer ? Retro.yellow : Colors.white,
    ).copyWith(fontFamily: AppConstants.displayFont, fontWeight: FontWeight.w400);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: s.gapSmall * 0.5),
      child: Row(
        children: [
          SizedBox(width: s.resultPlaceW, child: Text('${r.place})', style: style)),
          SizedBox(
            width: s.resultTimeW,
            child: Text(formatTime(r.seconds), style: style),
          ),
          Expanded(
            child: Text(r.name, style: style, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
