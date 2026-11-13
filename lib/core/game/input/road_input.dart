// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';

// Project imports:
import '../road/road_renderer.dart';
import 'gamepad_controls.dart';
import 'handlebar_pose.dart';

// Merges keyboard, gamepad, handlebar and tilt input into the rider controls.
mixin RoadInput on FlameGame {
  RoadRenderer get road;

  bool finishing = false;

  double _keySteer = 0;
  double _tiltSteer = 0;
  bool _keyThrottle = false;
  bool _keyBrake = false;
  bool _boost = false;
  bool _keyAttack = false;
  bool _accessoryAttack = false;
  GamepadControls _gamepad = GamepadControls.neutral;
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

  /// Combines keyboard, gamepad, handlebar and tilt input into the rider controls.
  void applyInput() {
    if (!isLoaded) return;
    if (finishing) {
      road
        ..steer = 0
        ..brake = true
        ..throttle = false
        ..boost = false;
      return;
    }
    final barSteer = _handlebars.steer;
    final combined = _keySteer + barSteer + _tiltSteer + _gamepad.steer;
    road.steer = combined.clamp(-1.0, 1.0).toDouble();
    // Analog controls are smooth, so the bike follows them directly.
    road.analogSteer =
        _keySteer == 0 &&
        (barSteer != 0 || _tiltSteer != 0 || _gamepad.steer != 0);
    // Releasing both gas grips brakes unless keyboard or controller gas is held.
    final barBrake =
        _handlebarsLatched &&
        !_handlebars.throttle &&
        !_keyThrottle &&
        !_gamepad.throttle;
    road.brake = _keyBrake || _gamepad.brake || barBrake;
    road.throttle =
        (_keyThrottle || _gamepad.throttle || _handlebars.throttle) &&
        !road.brake;
    road.boost =
        (_boost || _gamepad.boost) &&
        road.throttle &&
        !road.locked &&
        !road.crashed &&
        !road.recovering;
  }

  /// Updates the key steering, throttle and brake from pressed keys.
  void readKeys(Set<LogicalKeyboardKey> keysPressed) {
    bool anyDown(List<LogicalKeyboardKey> keys) =>
        keys.any(keysPressed.contains);
    _keySteer =
        (anyDown(_rightKeys) ? 1.0 : 0.0) - (anyDown(_leftKeys) ? 1.0 : 0.0);
    _keyThrottle = anyDown(_upKeys);
    _keyBrake = anyDown(_downKeys);
    _keyAttack = anyDown([_attackKey]);
    if (_keyThrottle || _keyBrake || _keySteer != 0) _handlebarsLatched = false;
    applyInput();
  }

  /// Clears all key, handlebar and tilt input.
  void clearInput() {
    _keySteer = 0;
    _tiltSteer = 0;
    _keyThrottle = false;
    _keyBrake = false;
    _boost = false;
    _keyAttack = false;
    _accessoryAttack = false;
    _gamepad = GamepadControls.neutral;
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
    _accessoryAttack = value;
  }

  /// Applies the latest gamepad controls.
  void setGamepadControls(GamepadControls controls) {
    _gamepad = controls;
    if (controls.throttle || controls.brake || controls.steer != 0) {
      _handlebarsLatched = false;
    }
    applyInput();
  }

  /// Holds boost while its accessory control is pressed.
  void setBoost(bool value) {
    _boost = value;
    applyInput();
  }

  /// The current handlebar pose.
  HandlebarPose get handlebars => _handlebars;

  /// True while any supported input is holding attack.
  bool get attack => _keyAttack || _accessoryAttack || _gamepad.attack;

  /// Applies the handlebar pose: either grip is gas and either steers.
  void setHandlebars(HandlebarPose pose) {
    _handlebars = pose;
    if (pose.anyHeld) _handlebarsLatched = true;
    applyInput();
  }
}
