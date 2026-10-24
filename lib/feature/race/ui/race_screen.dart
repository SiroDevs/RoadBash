// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/app_router/route_names.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/strings/controls_strings.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/audio/music_scope.dart';
import '../../../core/di/injectable.dart';
import '../../../core/game/hud/hud_strings.dart';
import '../../../core/game/input/tilt/tilt_controller.dart';
import '../../../core/game/input/touch_controls.dart';
import '../../../core/game/road_game.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../core/utils/app_util.dart';
import '../../../domain/models/player_profile.dart';
import '../../../domain/models/scene_id.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/race_cubit.dart';
import 'widgets/race_controls_menu.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, required this.scene});

  final SceneId scene;

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  late final RoadGame _game = _buildGame();
  late final TiltController _tilt = TiltController(onSteer: _game.setTouchSteer);

  /// Bumped when the menu opens or closes so the pedals start fresh: a finger
  /// that was down when the menu appeared never reports its release.
  int _inputEpoch = 0;
  bool _menuOpen = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncTilt(context.read<SettingsCubit>().state.profile);
    });
  }

  /// Tilt steers on phones and tablets unless "Use Screentouch" is on.
  void _syncTilt(PlayerProfile profile) {
    _tilt.invert = profile.invertTilt;
    if (isTouchDevice && !profile.useScreenTouch) {
      _tilt.start();
    } else {
      _tilt.stop();
    }
  }

  Future<void> _openControls() async {
    if (_menuOpen) return;
    _menuOpen = true;
    _game.pauseRace();
    _tilt.setPaused(true);
    setState(() => _inputEpoch++);
    await showRaceControlsMenu(context);
    _menuOpen = false;
    if (!mounted) return;
    _tilt.setPaused(false);
    _game.resumeRace();
    setState(() => _inputEpoch++);
  }

  @override
  void dispose() {
    _tilt.dispose();
    _game.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ControlsStrings.of(context);
    return MusicScope(
      track: MusicTrack.forScene(widget.scene),
      child: MultiBlocListener(
        listeners: [
          BlocListener<RaceCubit, RaceOutcome?>(
            listener: (context, outcome) {
              if (outcome != null) {
                context.goNamed(RouteNames.results, extra: outcome);
              }
            },
          ),
          // Sound switches and the steering mode apply live, mid-race.
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              _game.updateMix(state.profile);
              _syncTilt(state.profile);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              GameWidget(game: _game),
              if (isTouchDevice)
                Positioned.fill(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    buildWhen: (a, b) =>
                        a.profile.useScreenTouch != b.profile.useScreenTouch,
                    builder: (context, state) => TouchControls(
                      key: ValueKey(_inputEpoch),
                      showSteering: state.profile.useScreenTouch,
                      onSteer: _game.setTouchSteer,
                      onThrottle: _game.setTouchThrottle,
                      onBrake: _game.setTouchBrake,
                    ),
                  ),
                ),
              // iOS Safari only: motion data needs one tap to allow.
              ValueListenableBuilder<bool>(
                valueListenable: _tilt.needsPermission,
                builder: (context, needs, _) => needs
                    ? SafeArea(
                        child: Align(
                          alignment: const Alignment(0, -0.3),
                          child: FilledButton.icon(
                            onPressed: _tilt.requestPermission,
                            icon: const Icon(Icons.screen_rotation),
                            label: Text(t.enableTilt),
                            style: FilledButton.styleFrom(
                              backgroundColor: Retro.orange,
                              foregroundColor: Retro.ink,
                              textStyle: TextStyle(
                                fontSize: context.sizes.buttonText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: context.l10n.quitRace,
                        icon: const Icon(Icons.home, color: Colors.white70),
                        onPressed: () => context.goNamed(RouteNames.menu),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: t.title,
                        icon: const Icon(Icons.tune, color: Colors.white70),
                        onPressed: _openControls,
                      ),
                    ],
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
