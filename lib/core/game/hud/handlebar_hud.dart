// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ValueGetter;

// Project imports:
import '../input/handlebar_pose.dart';
import '../road/road_renderer.dart';
import 'handlebar_art.dart';
import 'handlebar_layout.dart';

/// Handlebars that pop up behind the dashboard and follow the player's hands.
class HandlebarHud extends PositionComponent {
  HandlebarHud(this.road, this.poseOf) : super(priority: 9);

  final RoadRenderer road;
  final ValueGetter<HandlebarPose> poseOf;

  final HandlebarArt _art = HandlebarArt();
  HandlebarLayout? _layout;
  double _rise = 0;
  final Map<HandlebarSide, double> _shown = {
    HandlebarSide.left: 0,
    HandlebarSide.right: 0,
  };

  static const double _riseSeconds = 0.7;
  static const double _followRate = 22;
  static const double _keySteerLean = 0.8;

  static const _heldLeft = Color(0x66FFFFFF);
  static const _heldRight = Color(0x663DBB5A);
  static final Rect _artBounds = Rect.fromLTWH(
    0,
    0,
    HandlebarArt.width,
    HandlebarArt.height,
  );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _layout = HandlebarLayout(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rise = math.min(1.0, _rise + dt / _riseSeconds);
    final pose = poseOf();
    final follow = math.min(1.0, dt * _followRate);
    for (final side in HandlebarSide.values) {
      final lean = HandlebarLayout.sign(side) * road.steer * _keySteerLean;
      final target = pose.isHeld(side) ? pose.offsetOf(side) : lean;
      _shown[side] = _shown[side]! + (target - _shown[side]!) * follow;
    }
  }

  @override
  void render(Canvas canvas) {
    final layout = _layout;
    if (layout == null) return;
    final pose = poseOf();
    final remaining = 1 - _rise;
    final drop = layout.popupDrop * remaining * remaining * remaining;
    for (final side in HandlebarSide.values) {
      _paintBar(canvas, layout, side, pose.isHeld(side), drop);
    }
  }

  /// Draws one bar's artwork from its hidden pivot out to its grip end.
  void _paintBar(
    Canvas canvas,
    HandlebarLayout layout,
    HandlebarSide side,
    bool held,
    double drop,
  ) {
    final shift = Offset(0, drop);
    final pivot = layout.pivot(side) + shift;
    final end = layout.end(side, _shown[side]!) + shift;
    final isLeft = side == HandlebarSide.left;
    final heading = math.atan2(end.dy - pivot.dy, end.dx - pivot.dx);
    final scale = layout.barLength / HandlebarArt.length;

    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(isLeft ? heading - math.pi : heading);
    canvas.scale(isLeft ? scale : -scale, scale);
    canvas.translate(-HandlebarArt.pivot.dx, -HandlebarArt.pivot.dy);
    if (held) {
      final tint = isLeft ? _heldLeft : _heldRight;
      canvas.saveLayer(
        _artBounds,
        Paint()..colorFilter = ColorFilter.mode(tint, BlendMode.srcATop),
      );
      _art.paint(canvas);
      canvas.restore();
    } else {
      _art.paint(canvas);
    }
    canvas.restore();
  }
}