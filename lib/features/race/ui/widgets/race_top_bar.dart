// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/game/road_game.dart';
import '../../../../core/router/route_names.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../settings/cubit/settings_cubit.dart';

// Quit, lap counter and quick actions shown above the race.
class RaceTopBar extends StatelessWidget {
  const RaceTopBar({
    super.key,
    required this.game,
    required this.laps,
    required this.paused,
    required this.showTouchActions,
    required this.onTogglePause,
    required this.onOpenControls,
  });

  final RoadGame game;
  final Stream<int> laps;
  final bool paused;
  final bool showTouchActions;
  final VoidCallback onTogglePause;
  final VoidCallback onOpenControls;

  /// Returns the lap counter, or the kilometres left on a one-road scene.
  String _progress(AppLocalizations l10n) {
    final race = game.race;
    if (race.countsLaps) return l10n.hudLap(race.lap, race.laps);
    final km = race.remainingKm(game.road.fullDistance);
    return l10n.hudRemaining(km.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          children: [
            IconButton(
              tooltip: l10n.quitRace,
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () => context.goNamed(RouteNames.menu),
            ),
            StreamBuilder<int>(
              stream: laps,
              builder: (context, snapshot) => Text(
                game.isLoaded ? _progress(l10n) : '',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: AppConstants.displayFont,
                  fontSize: context.sizes.body,
                ),
              ).padding(left: 4),
            ),
            const Spacer(),
            if (showTouchActions) ...[
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, next) =>
                    previous.profile.mute != next.profile.mute,
                builder: (context, state) {
                  final muted = state.profile.mute;
                  return IconButton(
                    tooltip: muted ? l10n.unmuteSound : l10n.muteSound,
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white70,
                    ),
                    onPressed: () =>
                        context.read<SettingsCubit>().setMute(!muted),
                  );
                },
              ),
              IconButton(
                tooltip: paused ? l10n.raceResume : l10n.pauseRace,
                icon: Icon(
                  paused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white70,
                ),
                onPressed: onTogglePause,
              ),
            ],
            IconButton(
              tooltip: l10n.controlsTitle,
              icon: const Icon(Icons.tune, color: Colors.white70),
              onPressed: onOpenControls,
            ),
          ],
        ),
      ),
    );
  }
}
