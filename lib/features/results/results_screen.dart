// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_constants.dart';
import '../../common/widgets/retro/retro_controls.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../l10n/l10n_extension.dart';
import '../audio/audio_catalog.dart';
import '../audio/music_scope.dart';
import '../game/race/race_result.dart';
import '../race/cubit/race_cubit.dart';

/// Top three finishers, plus the player's own row when they finished lower.
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
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RetroTitle(l10n.resultsTitle),
            const SizedBox(height: 20),
            for (final r in rows) _row(r),
            if (outcome.newBest) ...[
              const SizedBox(height: 12),
              Text(l10n.newBestTime,
                  style: retroBody(size: 26, color: Retro.yellow)),
            ],
            const Spacer(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                RetroButton(
                  l10n.raceAgain,
                  onTap: () => context.goNamed(RouteNames.race,
                      pathParameters: {'scene': result.scene.name}),
                ),
                RetroButton(l10n.backToMenu,
                    onTap: () => context.goNamed(RouteNames.menu)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ResultRow r) {
    final style = retroBody(
      size: 28,
      color: r.isPlayer ? Retro.yellow : Colors.white,
    ).copyWith(fontFamily: AppConstants.displayFont, fontWeight: FontWeight.w400);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 56, child: Text('${r.place})', style: style)),
          SizedBox(width: 130, child: Text(formatTime(r.seconds), style: style)),
          Expanded(
              child: Text(r.name, style: style, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
