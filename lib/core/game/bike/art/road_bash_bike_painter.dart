import 'dart:ui';

import '../../rider/look/rider_look.dart';
import '../../rider/rider_facing.dart';
import 'layers/rear_left_angle/rear_left_angle_layer.dart';
import 'layers/rear_right_angle/rear_right_angle_layer.dart';
import 'layers/rear_straight/rear_straight_layer.dart';

/// Paints the generated bike art in a rider-specific color palette.
class RoadBashBikePainter {
  /// Creates a two-tone color filter from [look]'s bike colors.
  RoadBashBikePainter(RiderLook look)
    : _bodyFilter = _mapBlackAndWhite(
        dark: look.bike.panelDark,
        base: look.bike.panel,
      );

  static const double width = 120;
  static const double height = 170;
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);

  final ColorFilter _bodyFilter;
  final RoadBashBikeRearStraightLayer _rear = RoadBashBikeRearStraightLayer();
  final RoadBashBikeRearLeftAngleLayer _left = RoadBashBikeRearLeftAngleLayer();
  final RoadBashBikeRearRightAngleLayer _right =
      RoadBashBikeRearRightAngleLayer();

  /// Paints the rear view selected by [facing].
  void paintRear(Canvas canvas, RiderFacing facing) {
    canvas.saveLayer(
      const Rect.fromLTWH(0, 0, width, height),
      Paint()..colorFilter = _bodyFilter,
    );
    switch (facing) {
      case RiderFacing.left:
        _left.paint(canvas);
        break;
      case RiderFacing.straight:
        _rear.paint(canvas);
        break;
      case RiderFacing.right:
        _right.paint(canvas);
        break;
    }
    canvas.restore();
  }

  /// Maps the generated black and white inks into the bike palette.
  static ColorFilter _mapBlackAndWhite({
    required Color dark,
    required Color base,
  }) {
    /// Converts one normalized color channel into its byte value.
    int channel(double value) => (value * 255).round().clamp(0, 255);
    final darkRed = channel(dark.r);
    final darkGreen = channel(dark.g);
    final darkBlue = channel(dark.b);
    return ColorFilter.matrix([
      (channel(base.r) - darkRed) / 255,
      0,
      0,
      0,
      darkRed.toDouble(),
      (channel(base.g) - darkGreen) / 255,
      0,
      0,
      0,
      darkGreen.toDouble(),
      (channel(base.b) - darkBlue) / 255,
      0,
      0,
      0,
      darkBlue.toDouble(),
      0,
      0,
      0,
      1,
      0,
    ]);
  }
}
