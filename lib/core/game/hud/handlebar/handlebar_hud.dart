// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ValueGetter;

// Project imports:
import '../../input/handlebar_pose.dart';
import '../../road/road_renderer.dart';
import '../../utils/canvas_text.dart';
import 'handlebar_art.dart';
import 'handlebar_layout.dart';

/// Linked handlebars that pop up behind the dashboard; the right one is the gas.
class HandlebarHud extends PositionComponent {
  HandlebarHud(this.road, this.poseOf, this.gasLabel) : super(priority: 9);

  final RoadRenderer road;
  final ValueGetter<HandlebarPose> poseOf;
  final String gasLabel;

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

  static const _gasColor = Color(0xFFFFFFFF);
  static const _heldLeft = Color(0x66FFFFFF);
  static const _gripGreen = Color(0xFF3DBB5A);

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
    final lean = pose.anyHeld ? pose.lean : road.steer * _keySteerLean;
    for (final side in HandlebarSide.values) {
      final target = HandlebarLayout.sign(side) * lean;
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
    final scale = layout.artScale;
    final extension = layout.pipeExtension;
    final artPivot = HandlebarArt.pivotFor(extension);

    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(isLeft ? heading - math.pi : heading);
    canvas.scale(isLeft ? scale : -scale, scale);
    canvas.translate(-artPivot.dx, -artPivot.dy);
    if (isLeft && held) {
      final bounds = Rect.fromLTWH(
        0,
        0,
        HandlebarArt.width + extension,
        HandlebarArt.height,
      );
      canvas.saveLayer(
        bounds,
        Paint()..colorFilter = const ColorFilter.mode(_heldLeft, BlendMode.srcATop),
      );
      _art.paint(canvas, extension: extension);
      canvas.restore();
    } else {
      _art.paint(
        canvas,
        extension: extension,
        gripColor: _gasOn(side, held) ? _gripGreen : null,
      );
    }
    canvas.restore();
    if (!isLeft) _paintGasLabel(canvas, pivot, heading, scale, artPivot);
  }

  /// True when the right grip should glow: gas from the bar or the up key.
  bool _gasOn(HandlebarSide side, bool held) =>
      side == HandlebarSide.right && (held || road.throttle);

  /// Prints the gas label inside the right grip, turned like the grip.
  void _paintGasLabel(
    Canvas canvas,
    Offset pivot,
    double heading,
    double scale,
    Offset artPivot,
  ) {
    final local = Offset(
      (artPivot.dx - HandlebarArt.gripCentre.dx) * scale,
      (HandlebarArt.gripCentre.dy - artPivot.dy) * scale,
    );
    final labelPosition = pivot +
        Offset(
          local.dx * math.cos(heading) - local.dy * math.sin(heading),
          local.dx * math.sin(heading) + local.dy * math.cos(heading),
        );
    paintText(
      canvas,
      gasLabel.toUpperCase(),
      labelPosition,
      HandlebarArt.gripThickness * scale * 0.75,
      _gasColor,
      weight: FontWeight.w800,
    );
  }
}
