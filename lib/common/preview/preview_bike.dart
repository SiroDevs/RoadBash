// Dart imports:
import 'dart:ui';

// Project imports:
import '../../core/game/rider/look/rider_look.dart';
import '../../core/game/rider/rider_sprite.dart';
import '../../core/game/road/traffic/road_actor.dart';

/// A bike standing in a scene preview, drawn like a rival.
class PreviewBike implements RoadActor {
  PreviewBike({
    required this.distance,
    required this.lateral,
    required RiderLook look,
    required double speed,
  }) : _sprite = RiderSprite(look: look, useSuppliedArt: true) {
    _sprite.pose
      ..speed = speed
      ..perspective = lateral.sign * 0.65;
  }

  @override
  final double distance;

  @override
  final double lateral;

  final RiderSprite _sprite;

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    _sprite.paintAt(canvas, ground, height / RiderSprite.height);
  }
}
