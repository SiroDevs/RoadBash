// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/game/race/race_result.dart';
import '../../../../core/game/road/scene_theme.dart';
import '../../../../domain/models/scene_id.dart';
import '../../../progress/cubit/progress_cubit.dart';

/// Shows the name, length and best stats of the selected scene.
class SceneInfo extends StatelessWidget {
  const SceneInfo({super.key, required this.scene, required this.km});

  final SceneId? scene;
  final double km;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = scene;
    final sizes = context.sizes;
    return Container(
      padding: EdgeInsets.all(sizes.infoPad),
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            id == null ? l10n.blurbReception : l10n.sceneBlurb(id),
            style: retroBody(size: sizes.body),
          ),
          if (id != null) ...[
            SizedBox(height: sizes.gap * 0.9),
            Text(
              SceneTheme.of(id).laps == 1
                  ? l10n.lengthOneWayLabel(km.toStringAsFixed(1))
                  : l10n.lengthLabel(km.toStringAsFixed(1), SceneTheme.of(id).laps),
              style: retroBody(size: sizes.small, color: Retro.yellow),
            ),
            BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, progress) {
                final stats = progress.statsFor(id);
                final best = stats.bestMs;
                final time = best == null
                    ? l10n.noTimeYet
                    : l10n.bestTimeLabel(formatTime(best / 1000));
                return Text(
                  '$time  |  ${l10n.racesWinsLabel(stats.races, stats.wins)}',
                  style: retroBody(size: sizes.caption, color: Retro.dim),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
