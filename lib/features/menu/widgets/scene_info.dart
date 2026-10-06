// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/retro/retro_style.dart';
import '../../../domain/models/scene_id.dart';
import '../../../l10n/l10n_extension.dart';
import '../../game/race/race_result.dart';
import '../../game/road/road_theme.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../../progress/cubit/progress_state.dart';

/// Description, race length and the player record for a scene.
class SceneInfo extends StatelessWidget {
  const SceneInfo({super.key, required this.scene, required this.km});

  final SceneId? scene;
  final double km;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = scene;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(id == null ? l10n.blurbReception : l10n.sceneBlurb(id),
            style: retroBody(size: 24)),
        if (id != null) ...[
          const SizedBox(height: 14),
          Text(l10n.lengthLabel(km.toStringAsFixed(1), SceneTheme.of(id).laps),
              style: retroBody(size: 22, color: Retro.yellow)),
          BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, progress) {
              final stats = progress.statsFor(id);
              final best = stats.bestMs;
              final time = best == null
                  ? l10n.noTimeYet
                  : l10n.bestTimeLabel(formatTime(best / 1000));
              return Text(
                '$time  |  ${l10n.racesWinsLabel(stats.races, stats.wins)}',
                style: retroBody(size: 20, color: Retro.dim),
              );
            },
          ),
        ],
      ],
    );
  }
}
