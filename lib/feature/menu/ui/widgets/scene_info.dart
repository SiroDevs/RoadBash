// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../../common/widgets/retro/controls/retro_link_button.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/game/race/race_result.dart';
import '../../../../domain/models/level_rules.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../progress/cubit/progress_cubit.dart';
import '../../cubit/menu_target.dart';

/// Shows the name, length and best stats of the selected scene.
class SceneInfo extends StatelessWidget {
  const SceneInfo({
    super.key,
    required this.target,
    required this.km,
    required this.laps,
    required this.canStartRide,
    required this.onStartRide,
  });

  final MenuTarget target;
  final double km;

  /// Laps of the selected scene at the player's level.
  final int laps;
  final bool canStartRide;
  final VoidCallback onStartRide;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = target.scene;
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
            id == null
                ? (target.isBoardroom
                      ? l10n.blurbBoardroom
                      : l10n.blurbReception)
                : l10n.sceneBlurb(id),
            style: retroBody(size: sizes.body),
          ),
          if (id != null) ...[
            SizedBox(height: sizes.gap * 0.9),
            Text(
              laps == 1
                  ? l10n.lengthOneWayLabel(km.toStringAsFixed(1))
                  : l10n.lengthLabel(km.toStringAsFixed(1), laps),
              style: retroBody(size: sizes.small, color: Retro.yellow),
            ),
            BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, progress) {
                final stats = progress.statsFor(id);
                final best = stats.bestMs;
                final time = best == null
                    ? l10n.noTimeYet
                    : l10n.bestTimeLabel(formatTime(best / 1000));
                final locked = !progress.career.rules.isOpen(id);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$time  |  ${l10n.racesWinsLabel(stats.races, stats.wins)}',
                      style: retroBody(size: sizes.caption, color: Retro.dim),
                    ),
                    if (locked)
                      Text(
                        l10n.sceneLocked(LevelRules.unlockLevelOf(id)),
                        style: retroBody(
                          size: sizes.small,
                          color: Retro.yellow,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          if (id != null && canStartRide) ...[
            SizedBox(height: sizes.gap),
            SizedBox(
              width: double.infinity,
              child: RetroButton(l10n.menuStartRide, onTap: onStartRide),
            ),
          ],
          SizedBox(height: sizes.gapSmall),
          RetroLinkButton(
            l10n.menuHowToPlay,
            onTap: () => _showControls(context),
          ),
        ],
      ),
    );
  }

  /// Opens the existing controls guide in a readable dialog.
  void _showControls(BuildContext context) {
    final sizes = context.sizes;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(context.l10n.menuHowToPlay),
        content: SingleChildScrollView(
          child: Text(
            context.l10n.controlsHelp,
            style: retroBody(size: sizes.small),
          ),
        ),
        actions: [
          RetroButton(
            context.l10n.commonBack,
            onTap: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }
}
