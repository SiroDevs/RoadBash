// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/router/route_names.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/audio_service.dart';
import '../../../common/widgets/retro/page/music_scope.dart';
import '../../../core/di/injectable.dart';
import '../../../core/game/hud/hud_strings.dart';
import '../../../core/game/input/tilt/tilt_controller.dart';
import 'widgets/touch_controls.dart';
import '../../../core/game/road_game.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../../core/utils/app_util.dart';
import '../../../domain/models/player_profile.dart';
import '../../../domain/models/scene_id.dart';
import '../../../common/l10n/l10n_extension.dart';
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
  late final TiltController _tilt = TiltController(onSteer: _game.setTiltSteer);

  int _inputEpoch = 0;
  bool _menuOpen = false;
  bool _paused = false;

  late final Stream<int> _laps = Stream.periodic(
    const Duration(milliseconds: 250),
    (_) => _game.isLoaded ? _game.race.lap : 1,
  ).distinct();

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

  void _syncTilt(PlayerProfile profile) {
    _tilt.invert = profile.invertTilt;
    if (isTouchDevice && !profile.useScreenTouch) {
      _tilt.start();
    } else {
      _tilt.stop();
    }
  }

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
    final l10n = context.l10n;
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
                  child: Text(
                    l10n.racePaused,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Anton',
                      fontSize: context.sizes.title,
                    ),
                  )
                      .alignment(Alignment.center)
                      .backgroundColor(Colors.black54)
                      .gestures(onTap: _togglePause),
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
                      StreamBuilder<int>(
                        stream: _laps,
                        builder: (context, snap) => Text(
                          _game.isLoaded
                              ? context.l10n.hudLap(
                                  _game.race.lap,
                                  _game.race.laps,
                                )
                              : '',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Anton',
                            fontSize: context.sizes.body,
                          ),
                        ).padding(left: 4),
                      ),
                      const Spacer(),
                      if (showTouchUi) ...[
                        BlocBuilder<SettingsCubit, SettingsState>(
                          buildWhen: (a, b) => a.profile.mute != b.profile.mute,
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
                          tooltip: _paused ? l10n.raceResume : l10n.pauseRace,
                          icon: Icon(
                            _paused ? Icons.play_arrow : Icons.pause,
                            color: Colors.white70,
                          ),
                          onPressed: _togglePause,
                        ),
                      ],
                      IconButton(
                        tooltip: l10n.controlsTitle,
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
      ),
    );
  }
}
