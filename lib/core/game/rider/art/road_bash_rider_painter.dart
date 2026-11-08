import 'dart:ui';

import '../look/rider_look.dart';
import '../rider_facing.dart';
import 'layers/rear_crouch/rear_crouch_layer.dart';
import 'layers/rear_crouch_left/rear_crouch_left_layer.dart';
import 'layers/rear_crouch_right/rear_crouch_right_layer.dart';
import 'layers/running/running_layer.dart';

/// Paints the generated rider art with the selected rider's colors.
class RoadBashRiderPainter {
  /// Creates color filters for [look]'s suit and helmet.
  RoadBashRiderPainter(this.look)
    : _suitFilter = _mapPalette(
        dark: look.backPatch,
        base: look.suit,
        accent: look.stripe,
      ),
      _helmetFilter = _mapPalette(
        dark: look.helmetShade,
        base: look.helmet,
        accent: look.stripeEdge,
      );

  static const double width = 120;
  static const double height = 170;
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);
  static const Color colorED1C24 = Color(0xFFED1C24);

  final RiderLook look;
  final ColorFilter _suitFilter;
  final ColorFilter _helmetFilter;
  final RoadBashRiderRearCrouchLayer _rear = RoadBashRiderRearCrouchLayer();
  final RoadBashRiderRearCrouchLeftLayer _left =
      RoadBashRiderRearCrouchLeftLayer();
  final RoadBashRiderRearCrouchRightLayer _right =
      RoadBashRiderRearCrouchRightLayer();
  final RoadBashRiderRunningLayer _running = RoadBashRiderRunningLayer();

  /// Paints the rear pose facing [facing].
  void paintRear(Canvas canvas, RiderFacing facing) {
    _paintPalette(canvas, _suitFilter, (target) => _paintSuit(target, facing));
    _paintPalette(
      canvas,
      _helmetFilter,
      (target) => _paintHelmet(target, facing),
    );
  }

  /// Paints the runner pose with this rider's colors.
  void paintRunning(Canvas canvas) {
    _paintPalette(canvas, _suitFilter, (target) {
      _running.paintBody(target);
      _running.paintLegs(target);
    });
    _paintPalette(canvas, _helmetFilter, _running.paintHelmet);
  }

  /// Paints suit layers in their original overlap order.
  void _paintSuit(Canvas canvas, RiderFacing facing) {
    switch (facing) {
      case RiderFacing.left:
        _left.paintBody(canvas);
        _left.paintLegs(canvas);
        break;
      case RiderFacing.straight:
        _rear.paintBody(canvas);
        _rear.paintLegs(canvas);
        break;
      case RiderFacing.right:
        _right.paintLegs(canvas);
        _right.paintBody(canvas);
        break;
    }
  }

  /// Paints the helmet for the selected rear pose.
  void _paintHelmet(Canvas canvas, RiderFacing facing) {
    switch (facing) {
      case RiderFacing.left:
        _left.paintHelmet(canvas);
        break;
      case RiderFacing.straight:
        _rear.paintHelmet(canvas);
        break;
      case RiderFacing.right:
        _right.paintHelmet(canvas);
        break;
    }
  }

  /// Applies a color filter to one generated layer group.
  void _paintPalette(
    Canvas canvas,
    ColorFilter filter,
    void Function(Canvas) paint,
  ) {
    canvas.saveLayer(
      const Rect.fromLTWH(0, 0, width, height),
      Paint()..colorFilter = filter,
    );
    paint(canvas);
    canvas.restore();
  }

  /// Maps the generated black, white and red inks into the rider palette.
  static ColorFilter _mapPalette({
    required Color dark,
    required Color base,
    required Color accent,
  }) {
    List<double> row(int darkChannel, int baseChannel, int accentChannel) {
      final total = (baseChannel - darkChannel) / 255;
      final red = (accentChannel - darkChannel - 36 * total) / 201;
      final blue = total - red;
      return [red, 0, blue, 0, darkChannel.toDouble()];
    }

    return ColorFilter.matrix([
      ...row(_channel(dark.r), _channel(base.r), _channel(accent.r)),
      ...row(_channel(dark.g), _channel(base.g), _channel(accent.g)),
      ...row(_channel(dark.b), _channel(base.b), _channel(accent.b)),
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  /// Converts one normalized color channel into its byte value.
  static int _channel(double value) => (value * 255).round().clamp(0, 255);
}
