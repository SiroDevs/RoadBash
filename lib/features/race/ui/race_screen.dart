// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/widgets/retro/page/music_scope.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/di/injectable.dart';
import '../../../core/game/hud/hud_strings.dart';
import '../../../core/game/input/tilt/tilt_controller.dart';
import '../../../core/game/road_game.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/app_util.dart';
import '../../../domain/models/player_profile.dart';
import '../../../domain/models/scene_id.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/race_cubit.dart';
import 'widgets/race_controls_menu.dart';
import 'widgets/race_pause_overlay.dart';
import 'widgets/race_top_bar.dart';
import 'widgets/touch_controls.dart';

/// Screen that hosts a race for the given scene.
class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, required this.scene});

  final SceneId scene;

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

/// State for [RaceScreen]; owns the game, tilt input and pause handling.
class _RaceScreenState extends State<RaceScreen> {
  late final RoadGame _game = _buildGame();
  late final TiltController _tilt = TiltController(onSteer: _game.setTiltSteer);

  int _inputEpoch = 0;
  bool _menuOpen = false;
  bool _paused = false;

  late final Stream<int> _laps = Stream.periodic(
    const Duration(milliseconds: 250),
    (_) => _game.isLoaded ? _game.race.lap : 1,
  ).distinct();

  /// Creates the road game with the player's profile and HUD strings.
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
      onPauseKey: _togglePause,
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

  /// Starts or stops tilt steering to match the profile settings.
  void _syncTilt(PlayerProfile profile) {
    _tilt.invert = profile.invertTilt;
    if (isTouchDevice && !profile.useScreenTouch) {
      _tilt.start();
    } else {
      _tilt.stop();
    }
  }

  /// Pauses or resumes the race.
  void _togglePause() {
    if (_menuOpen) return;
    final pausing = !_paused;
    setState(() {
      _paused = pausing;
      _inputEpoch++;
    });
    _tilt.setPaused(pausing);
    if (pausing) {
      _game.pauseRace();
    } else {
      _game.resumeRace();
    }
  }

  /// Pauses the race and shows the controls menu, then resumes if needed.
  Future<void> _openControls() async {
    if (_menuOpen) return;
    _menuOpen = true;
    final wasPaused = _paused;
    _game.pauseRace();
    _tilt.setPaused(true);
    setState(() => _inputEpoch++);
    await showRaceControlsMenu(context);
    _menuOpen = false;
    if (!mounted || wasPaused) return;
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
    final screenTouch = context.select<SettingsCubit, bool>(
      (c) => c.state.profile.useScreenTouch,
    );
    final showTouchUi = isTouchDevice || screenTouch;
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
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              _game.updateMix(state.profile);
              _syncTilt(state.profile);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Listener(
            onPointerUp: (_) {
              if (_tilt.needsPermission.value) _tilt.requestPermission();
            },
            child: Stack(
              children: [
                GameWidget(game: _game),
                if (showTouchUi)
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
                if (_paused)
                  Positioned.fill(
                    child: RacePauseOverlay(onTap: _togglePause),
                  ),
                RaceTopBar(
                  game: _game,
                  laps: _laps,
                  paused: _paused,
                  showTouchActions: showTouchUi,
                  onTogglePause: _togglePause,
                  onOpenControls: _openControls,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
