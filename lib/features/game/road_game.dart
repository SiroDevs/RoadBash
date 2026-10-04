// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flame/input.dart';

// Project imports:
import '../../common/widgets/game/rider_component.dart';
import '../../common/widgets/game/road_renderer.dart';

class RoadGame extends FlameGame with KeyboardEvents {
  late final RoadRenderer road;
  late final RiderComponent rider;

  double _keySteer = 0;
  double _touchSteer = 0;
  bool _keyBrake = false;
  bool _touchBrake = false;

  @override
  Future<void> onLoad() async {
    road = RoadRenderer();
    rider = RiderComponent(road);
    await addAll([road, rider]);
  }

  void _applyInput() {
    if (!isLoaded) return;
    final s = _keySteer + _touchSteer;
    road.steer = s > 1 ? 1 : (s < -1 ? -1 : s);
    road.brake = _keyBrake || _touchBrake;
    road.throttle = !road.brake;
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
}
