// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flame/input.dart';

// Project imports:
import '../../domain/models/player_profile.dart';
import '../../domain/models/scene_id.dart';
import '../audio/audio_service.dart';
import 'audio/ride_audio.dart';
import 'hud/dashboard_hud.dart';
import 'hud/hud_strings.dart';
import 'input/road_input.dart';
import 'race/race_controller.dart';
import 'race/race_result.dart';
import 'race/rival_racer.dart';
import 'rider/rider_component.dart';
import 'road/road_renderer.dart';
import 'road/scene_theme.dart';
import 'road/traffic/rival_overlay.dart';
import 'road/traffic/road_traffic.dart';

/// Flame game that runs a race on the road.
class RoadGame extends FlameGame with KeyboardEvents, RoadInput {
  RoadGame({
    required this.scene,
    required this.mix,
    required this.audio,
    required this.strings,
    required this.playerName,
    required this.onFinished,
    this.onPauseKey,
  });

  final SceneId scene;
  PlayerProfile mix;
  final AudioService audio;
  final HudStrings strings;
  final String playerName;
  final ValueChanged<RaceResult> onFinished;
  final VoidCallback? onPauseKey;

  @override
  late final RoadRenderer road;
  late final RaceController race;
  late final List<RivalRacer> racers;
  RideAudio? _ride;

  bool _menuPaused = false;
  bool _notified = false;
  bool _shutDown = false;
  double _finishDelay = 2.4;

  @override
  Future<void> onLoad() async {
    final theme = SceneTheme.of(scene);
    road = RoadRenderer(theme);
    race = RaceController(
      scene: scene,
      laps: theme.laps,
      lapLength: road.track.length,
      runOut: road.track.runOutLength,
      playerName: playerName,
    );
    racers = [
      for (var i = 0; i < race.rivals.length; i++)
        RivalRacer(race.rivals[i], i, theme.lanes),
    ];
    for (final racer in racers) {
      racer.peers = racers;
    }
    road.traffic = RoadTraffic(racers, theme.lanes);
    await addAll([
      road,
      RiderComponent(road),
      RivalOverlay(road),
      DashboardHud(road, race, strings),
    ]);
    if (_shutDown) return;
    final ride = RideAudio(
      mix: mix,
      service: audio,
      road: road,
      race: race,
      racers: racers,
    );
    _ride = ride;
    unawaited(ride.start());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLoaded) return;

    road.locked = race.countdown > 0;
    applyInput();
    race.update(dt, road.fullDistance, road.speed);
    for (final r in racers) {
      r.update(dt, race, road);
    }

    if (race.finished && !finishing) {
      finishing = true;
      applyInput();
    }
    if (finishing && !_notified && (_finishDelay -= dt) <= 0 && _fieldHome) {
      _notified = true;
      onFinished(race.buildResult());
    }
    _ride?.update(dt);
  }

  /// True when the finish delay is over or every rival has settled.
  bool get _fieldHome =>
      _finishDelay < -3.6 || racers.every((r) => r.settled);

  /// Applies a new player profile to the game and its audio.
  void updateMix(PlayerProfile profile) {
    mix = profile;
    _ride?.mix = profile;
  }

  /// True while the race is paused from the menu.
  bool get menuPaused => _menuPaused;

  /// Pauses the race and silences input and audio.
  void pauseRace() {
    if (_menuPaused) return;
    _menuPaused = true;
    clearInput();
    pauseEngine();
    _ride?.pause();
  }

  /// Resumes a race paused from the menu.
  void resumeRace() {
    if (!_menuPaused) return;
    _menuPaused = false;
    resumeEngine();
    _ride?.resume();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      onPauseKey?.call();
      return KeyEventResult.handled;
    }
    readKeys(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (_menuPaused) return;
    if (state == AppLifecycleState.resumed) {
      _ride?.resume();
    } else {
      _ride?.pause();
    }
  }

  /// Stops audio and releases the game's resources.
  Future<void> shutdown() async {
    _shutDown = true;
    final ride = _ride;
    _ride = null;
    await ride?.dispose();
  }
}
