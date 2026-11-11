// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';

/// One rider leg, with its knee details kept inside the painter.
class RiderLeg {
  RiderLeg(InkedSheet sheet, String id)
    : _thigh = sheet.part('${id}Thigh'),
      _shin = sheet.part('${id}Shin'),
      hip = sheet.anchor('$id.hip'),
      knee = sheet.anchor('$id.knee'),
      ankle = sheet.anchor('$id.ankle');

  final InkedPart _thigh;
  final InkedPart _shin;
  final Offset hip;
  final Offset knee;
  final Offset ankle;

  /// Paints the complete leg with optional hip and knee turns.
  void paint(Canvas canvas, {double hipAngle = 0, double kneeAngle = 0}) {
    PartMotion.around(canvas, hip, () {
      _thigh.paint(canvas);
      PartMotion.around(
        canvas,
        knee,
        () => _shin.paint(canvas),
        angle: kneeAngle,
      );
    }, angle: hipAngle);
  }

  /// Paints this leg with a pose-specific lower-leg painter.
  void paintWithLowerLeg(
    Canvas canvas,
    void Function(Canvas canvas, InkedPart lowerLeg) paintLowerLeg,
  ) {
    _thigh.paint(canvas);
    paintLowerLeg(canvas, _shin);
  }

  /// Paints a knee fill beneath its joint pads.
  void paintKnee(Canvas canvas, double radius) {
    final index = _shin.part.shapes.indexWhere(
      (shape) => shape.name.endsWith('Leg'),
    );
    canvas.drawCircle(knee, radius, _shin.inks[index < 0 ? 0 : index].fill);
  }
}
