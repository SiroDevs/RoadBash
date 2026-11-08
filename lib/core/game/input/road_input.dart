// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';

// Project imports:
import '../road/road_renderer.dart';
import 'handlebar_pose.dart';

// Merges keyboard, handlebar and tilt input into the rider controls.
mixin RoadInput on FlameGame {
  RoadRenderer get road;

  bool finishing = false;

  double _keySteer = 0;
  double _tiltSteer = 0;
  bool _keyThrottle = false;
  bool _keyBrake = false;
  bool attack = false;
  HandlebarPose _handlebars = HandlebarPose.rest;
  bool _handlebarsLatched = false;

  static final _leftKeys = [
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  ];
  static final _rightKeys = [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyD,
  ];
  static final _upKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.keyW];
  static final _downKeys = [
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.keyS,
  ];
  static const _attackKey = LogicalKeyboardKey.keyC;

  /// Combines key, handlebar and tilt input into the rider controls.
  void applyInput() {
    if (!isLoaded) return;
    if (finishing) {
      road
        ..steer = 0
        ..brake = true
        ..throttle = false;
      return;
    }
    final barSteer = _handlebars.steer;
    final combined = _keySteer + barSteer + _tiltSteer;
    road.steer = combined.clamp(-1.0, 1.0).toDouble();
    // Bars and tilt are already smooth, so the bike follows them directly.
    road.analogSteer = _keySteer == 0 && (barSteer != 0 || _tiltSteer != 0);
    // Letting go of the right bar brakes.
    final barBrake = _handlebarsLatched && !_handlebars.throttle;
    road.brake = _keyBrake || barBrake;
    road.throttle = (_keyThrottle || _handlebars.throttle) && !road.brake;
  }

  /// Updates the key steering, throttle and brake from pressed keys.
  void readKeys(Set<LogicalKeyboardKey> keysPressed) {
    bool anyDown(List<LogicalKeyboardKey> keys) =>
        keys.any(keysPressed.contains);
    _keySteer = (anyDown(_rightKeys) ? 1.0 : 0.0) -
        (anyDown(_leftKeys) ? 1.0 : 0.0);
    _keyThrottle = anyDown(_upKeys);
    _keyBrake = anyDown(_downKeys);
    attack = anyDown([_attackKey]);
    if (_keyThrottle || _keyBrake || _keySteer != 0) _handlebarsLatched = false;
    applyInput();
  }

  /// Clears all key, handlebar and tilt input.
  void clearInput() {
    _keySteer = 0;
    _tiltSteer = 0;
    _keyThrottle = false;
    _keyBrake = false;
    attack = false;
    _handlebars = HandlebarPose.rest;
    _handlebarsLatched = false;
    applyInput();
  }

  // Analog steering from the tilt sensor, -1..1.
  void setTiltSteer(double value) {
    _tiltSteer = value;
    applyInput();
  }

  void setAttack(bool value) {
    attack = value;
  }

  /// The current handlebar pose.
  HandlebarPose get handlebars => _handlebars;

  /// Applies the handlebar pose: the right bar is gas, either bar steers.
  void setHandlebars(HandlebarPose pose) {
    _handlebars = pose;
    if (pose.rightHeld) _handlebarsLatched = true;
    applyInput();
  }
}
