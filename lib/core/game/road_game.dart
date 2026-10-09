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
import '../../core/audio/audio_service.dart';
import 'audio/ride_audio.dart';
import 'hud/dashboard_hud.dart';
import 'hud/hud_strings.dart';
import 'race/race_controller.dart';
import 'race/race_result.dart';
import 'rider/rider_component.dart';
import 'road/road_renderer.dart';
import 'road/road_theme.dart';

class RoadGame extends FlameGame with KeyboardEvents {
  RoadGame({
    required this.scene,
    required this.mix,
    required this.audio,
    required this.strings,
    required this.playerName,
    required this.onFinished,
  });

  final SceneId scene;
  final PlayerProfile mix;
  final AudioService audio;
  final HudStrings strings;
  final String playerName;
  final ValueChanged<RaceResult> onFinished;

  late final RoadRenderer road;
  late final RaceController race;
  RideAudio? _ride;

  double _keySteer = 0, _touchSteer = 0;
  bool _keyThrottle = false, _touchThrottle = false;
  bool _keyBrake = false, _touchBrake = false;

  bool _finishing = false;
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
      playerName: playerName,
    );
    await addAll([
      road,
      RiderComponent(road),
      DashboardHud(road, race, strings),
    ]);
    if (_shutDown) return;
    final ride = RideAudio(mix: mix, service: audio, road: road, race: race);
    _ride = ride;
    unawaited(ride.start());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLoaded) return;

    road.locked = race.countdown > 0;
    _keyThrottle = true;
    _applyInput();
    race.update(dt, road.fullDistance, road.speed);

    if (race.finished && !_finishing) {
      _finishing = true;
      _applyInput();
    }
    if (_finishing && !_notified && (_finishDelay -= dt) <= 0) {
      _notified = true;
      onFinished(race.buildResult());
    }
    _ride?.update(dt);
  }

  void _applyInput() {
    if (!isLoaded) return;
    if (_finishing) {
      road
        ..steer = 0
        ..brake = true
        ..throttle = false;
      return;
    }
    final s = _keySteer + _touchSteer;
    road.steer = s.clamp(-1.0, 1.0).toDouble();
    road.brake = _keyBrake || _touchBrake;
    road.throttle = (_keyThrottle || _touchThrottle) && !road.brake;
  }

  void setTouchSteer(double v) {
    _touchSteer = v;
    _applyInput();
  }

  void setTouchThrottle(bool v) {
    _touchThrottle = v;
    _applyInput();
  }

  void setTouchBrake(bool v) {
    _touchBrake = v;
    _applyInput();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    bool any(List<LogicalKeyboardKey> list) => list.any(keys.contains);
    _keySteer = (any(_right) ? 1.0 : 0.0) - (any(_left) ? 1.0 : 0.0);
    _keyThrottle = any(_up);
    _keyBrake = any(_down);
    _applyInput();
    return KeyEventResult.handled;
  }

  static final _left = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.keyA];
  static final _right = [LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.keyD];
  static final _up = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.keyW];
  static final _down = [
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.keyS,
    LogicalKeyboardKey.space,
  ];

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state == AppLifecycleState.resumed) {
      _ride?.resume();
    } else {
      _ride?.pause();
    }
  }

  Future<void> shutdown() async {
    _shutDown = true;
    final ride = _ride;
    _ride = null;
    await ride?.dispose();
  }
}
