// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flame/input.dart';

// Project imports:
import '../../common/widgets/game/rider_component.dart';
import '../../common/widgets/game/road_renderer.dart';
import '../../common/widgets/game/road_theme.dart';
import 'game_audio.dart';
import 'game_settings.dart';
import 'hud/dashboard_hud.dart';
import 'race_controller.dart';
import 'race_result.dart';

class RoadGame extends FlameGame with KeyboardEvents {
  RoadGame({required this.scene, this.onFinished});

  final SceneId scene;

  /// Called once, a moment after the rider crosses the finish line.
  final void Function(RaceResult result)? onFinished;

  late final RoadRenderer road;
  late final RaceController race;
  GameAudio? _audio;

  double _keySteer = 0;
  double _touchSteer = 0;
  bool _keyBrake = false;
  bool _touchBrake = false;

  bool _finishing = false;
  bool _notified = false;
  bool _shutDown = false;
  double _finishDelay = 2.2;

  @override
  Future<void> onLoad() async {
    final theme = SceneTheme.of(scene);
    final settings = GameSettings.instance;
    road = RoadRenderer(theme);
    race = RaceController(
      scene: scene,
      laps: theme.laps,
      lapLength: road.track.length,
      playerName: settings.playerName,
    );
    await addAll([road, RiderComponent(road), DashboardHud(road, race)]);
    if (_shutDown) return;
    final audio = GameAudio(settings);
    _audio = audio;
    unawaited(audio.start());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLoaded) return;

    road.locked = race.countdown > 0;
    race.update(dt, road.fullDistance, road.speed);

    if (race.finished && !_finishing) {
      _finishing = true;
      _applyInput();
    }
    if (_finishing && !_notified) {
      _finishDelay -= dt;
      if (_finishDelay <= 0) {
        _notified = true;
        onFinished?.call(race.buildResult());
      }
    }

    _audio?.update(
      dt,
      rpm: road.rpm,
      load: road.engineLoad,
      skidding: road.skidding,
    );
  }

  void _applyInput() {
    if (!isLoaded) return;
    if (_finishing) {
      road.steer = 0;
      road.brake = true;
      road.throttle = false;
      return;
    }
    final s = _keySteer + _touchSteer;
    road.steer = s > 1 ? 1.0 : (s < -1 ? -1.0 : s);
    road.brake = _keyBrake || _touchBrake;
    road.throttle = !road.brake; // throttle is automatic
  }

  void setTouchSteer(double v) {
    _touchSteer = v;
    _applyInput();
  }

  void setTouchBrake(bool v) {
    _touchBrake = v;
    _applyInput();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    final left = keys.contains(LogicalKeyboardKey.arrowLeft) ||
        keys.contains(LogicalKeyboardKey.keyA);
    final right = keys.contains(LogicalKeyboardKey.arrowRight) ||
        keys.contains(LogicalKeyboardKey.keyD);
    _keySteer = (right ? 1.0 : 0.0) - (left ? 1.0 : 0.0);
    _keyBrake = keys.contains(LogicalKeyboardKey.arrowDown) ||
        keys.contains(LogicalKeyboardKey.keyS) ||
        keys.contains(LogicalKeyboardKey.space);
    _applyInput();
    return KeyEventResult.handled;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state == AppLifecycleState.resumed) {
      _audio?.resume();
    } else {
      _audio?.pause();
    }
  }

  /// Stops the sounds. Call from the screen's `dispose`.
  Future<void> shutdown() async {
    _shutDown = true;
    final audio = _audio;
    _audio = null;
    await audio?.dispose();
  }
}
