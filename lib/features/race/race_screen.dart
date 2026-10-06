// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../core/di/injectable.dart';
import '../../core/utils/app_util.dart';
import '../../domain/models/scene_id.dart';
import '../../l10n/l10n_extension.dart';
import '../audio/audio_catalog.dart';
import '../audio/audio_service.dart';
import '../audio/music_scope.dart';
import '../game/hud/hud_strings.dart';
import '../game/input/touch_controls.dart';
import '../game/road_game.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/race_cubit.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, required this.scene});

  final SceneId scene;

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  late final RoadGame _game = _buildGame();

  RoadGame _buildGame() {
    final l10n = context.l10n;
    final profile = context.read<SettingsCubit>().state.profile;
    final race = context.read<RaceCubit>();
    return RoadGame(
      scene: widget.scene,
      mix: profile,
      audio: getIt<AudioService>(),
      playerName: profile.displayName(l10n),
      onFinished: race.finish,
      strings: HudStrings(
        go: l10n.hudGo,
        finish: l10n.hudFinish,
        holdGas: l10n.hudHoldGas,
        speedUnit: l10n.hudSpeedUnit,
        rpmUnit: l10n.hudRpmUnit,
        lap: l10n.hudLap,
      ),
    );
  }

  @override
  void dispose() {
    _game.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicScope(
      track: MusicTrack.forScene(widget.scene),
      child: BlocListener<RaceCubit, RaceOutcome?>(
        listener: (context, outcome) {
          if (outcome != null) {
            context.goNamed(RouteNames.results, extra: outcome);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              GameWidget(game: _game),
              if (isMobile)
                TouchControls(
                  onSteer: _game.setTouchSteer,
                  onThrottle: _game.setTouchThrottle,
                  onBrake: _game.setTouchBrake,
                ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    tooltip: context.l10n.quitRace,
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => context.goNamed(RouteNames.menu),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
