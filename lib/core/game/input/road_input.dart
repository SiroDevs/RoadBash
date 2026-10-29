// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';

// Project imports:
import '../road/road_renderer.dart';

// Merges keyboard, touch and tilt input into the rider controls.
mixin RoadInput on FlameGame {
  RoadRenderer get road;

  bool finishing = false;

  double _keySteer = 0;
  double _touchSteer = 0;
  double _tiltSteer = 0;
  bool _keyThrottle = false;
  bool _touchThrottle = false;
  bool _keyBrake = false;
  bool _touchBrake = false;

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

  void applyInput() {
    if (!isLoaded) return;
    if (finishing) {
      road
        ..steer = 0
        ..brake = true
        ..throttle = false;
      return;
    }
    final combined = _keySteer + _touchSteer + _tiltSteer;
    road.steer = combined.clamp(-1.0, 1.0).toDouble();
    // Tilt is already smooth, so the bike follows it directly.
    road.analogSteer = _keySteer == 0 && _touchSteer == 0 && _tiltSteer != 0;
    road.brake = _keyBrake || _touchBrake;
    road.throttle = (_keyThrottle || _touchThrottle) && !road.brake;
  }

  void readKeys(Set<LogicalKeyboardKey> keysPressed) {
    bool anyDown(List<LogicalKeyboardKey> keys) =>
        keys.any(keysPressed.contains);
    _keySteer = (anyDown(_rightKeys) ? 1.0 : 0.0) -
        (anyDown(_leftKeys) ? 1.0 : 0.0);
    _keyThrottle = anyDown(_upKeys);
    _keyBrake = anyDown(_downKeys);
    applyInput();
  }

  void clearInput() {
    _keySteer = 0;
    _touchSteer = 0;
    _tiltSteer = 0;
    _keyThrottle = _touchThrottle = false;
    _keyBrake = _touchBrake = false;
    applyInput();
  }

  // Analog steering from the tilt sensor, -1..1.
  void setTiltSteer(double value) {
    _tiltSteer = value;
    applyInput();
  }

  void setTouchSteer(double value) {
    _touchSteer = value;
    applyInput();
  }

  void setTouchThrottle(bool pressed) {
    _touchThrottle = pressed;
    applyInput();
  }

  void setTouchBrake(bool pressed) {
    _touchBrake = pressed;
    applyInput();
  }
}
