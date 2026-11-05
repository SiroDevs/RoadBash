// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart' show ValueGetter;

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../input/handlebar_pose.dart';
import '../../road/road_renderer.dart';
import 'handlebar_art.dart';
import 'handlebar_layout.dart';

/// Shared motion of the handlebar, used by its pipe and its grips.
///
/// The pipe and the grips are drawn by separate components at different depths,
/// so this one owns the layout, the pop-up and the smoothed lean. It draws
/// nothing itself.
class HandlebarRig extends Component {
  HandlebarRig(this.road, this.poseOf);

  final RoadRenderer road;
  final ValueGetter<HandlebarPose> poseOf;

  final HandlebarArt art = HandlebarArt();
  HandlebarLayout? layout;

  double _rise = 0;
  double _lean = 0;

  static const double _riseSeconds = 0.7;
  static const double _followRate = 22;
  static const double _keySteerLean = 0.8;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    layout = HandlebarLayout(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rise = math.min(1.0, _rise + dt / _riseSeconds);
    final pose = poseOf();
    final target = pose.anyHeld ? pose.lean : road.steer * _keySteerLean;
    _lean += (target - _lean) * math.min(1.0, dt * _followRate);
  }

  /// True while the left grip is held.
  bool get leftHeld => poseOf().leftHeld;

  /// True when the right grip should glow: gas from the grip or the up key.
  bool get gasOn => poseOf().rightHeld || road.throttle;

  /// How far the handlebar is turned right now, in radians.
  double get angle => layout?.tilt(_lean) ?? 0;

  /// How far below its place the handlebar is while it pops up.
  double get drop {
    final remaining = 1 - _rise;
    return (layout?.popupDrop ?? 0) * remaining * remaining * remaining;
  }

  /// Runs [draw] with the canvas moved into artwork coordinates: scaled,
  /// turned and placed exactly as the handlebar is on screen.
  void inArtSpace(Canvas canvas, void Function(HandlebarLayout layout) draw) {
    final layout = this.layout;
    if (layout == null) return;
    canvas.save();
    canvas.translate(layout.centreX, layout.pivotY + drop);
    canvas.rotate(angle);
    canvas.scale(layout.artScale);
    canvas.translate(-HandlebarArt.pivot.dx, -HandlebarArt.pivot.dy);
    draw(layout);
    canvas.restore();
  }

  /// Returns where a point of the artwork lands on screen.
  Offset toScreen(Offset artPoint) {
    final layout = this.layout;
    if (layout == null) return Offset.zero;
    final local = (artPoint - HandlebarArt.pivot) * layout.artScale;
    final a = angle;
    final cosA = math.cos(a);
    final sinA = math.sin(a);
    return Offset(
      layout.centreX + local.dx * cosA - local.dy * sinA,
      layout.pivotY + drop + local.dx * sinA + local.dy * cosA,
    );
  }
}
