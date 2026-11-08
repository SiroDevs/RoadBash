import 'dart:ui';

import '../look/rider_look.dart';
import '../rider_facing.dart';
import 'layers/rear_crouch/rear_crouch_layer.dart';
import 'layers/rear_crouch_left/rear_crouch_left_layer.dart';
import 'layers/rear_crouch_right/rear_crouch_right_layer.dart';
import 'layers/running/running_layer.dart';

class RoadBashRiderPainter {
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

  void paintRear(Canvas canvas, RiderFacing facing) {
    final layer = switch (facing) {
      RiderFacing.left => _left,
      RiderFacing.straight => _rear,
      RiderFacing.right => _right,
    };
    _paintPalette(canvas, _suitFilter, (target) {
      layer.paintBody(target);
      layer.paintLegs(target);
    });
    _paintPalette(canvas, _helmetFilter, layer.paintHelmet);
  }

  void paintRunning(Canvas canvas) {
    _paintPalette(canvas, _suitFilter, (target) {
      _running.paintBody(target);
      _running.paintLegs(target);
    });
    _paintPalette(canvas, _helmetFilter, _running.paintHelmet);
  }

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
      ...row(dark.red, base.red, accent.red),
      ...row(dark.green, base.green, accent.green),
      ...row(dark.blue, base.blue, accent.blue),
      0, 0, 0, 1, 0,
    ]);
  }
}
